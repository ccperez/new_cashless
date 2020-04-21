import jwt from 'jsonwebtoken';
import User from '../models/User';

import validateInput from '../shared/validations/common';
import { sendResetSecureEmail, sendConfirmedResetSecureEmail, sendResetSecureCompletedEmail } from '../mailer';

export default {
  requestResetSecure: (req, res) => {
    const { phone } = req.body;
    const { errors, isValid } = validateInput({ phone }, ['phone']);

    const userRequestResetSecure = (phone) => {
      User.where({ phone: phone }).fetch().then(user => {
        if (user && user.isConfirmed()) {
          const jsonUser = { email: user.get('email'), name: user.get('name'), confirmationCode: user.generateConfirmationCode() };
          sendResetSecureEmail(jsonUser);
          res.json({ result: 1, description: 'request reset password' });
        } else {
          res.status(400).json({ error: 'Phone number not yet confirm' });
        }
      }).catch(
        err => res.status(500).json({ error: 'Phone number not found' })
      );
    };

    isValid ? userRequestResetSecure(phone) : res.status(400).json(errors);
  },

  confirmedRequestResetSecure: (req, res) => {
    const { confirmationCode } = req.body;
    User.where({ reset_secure_confirmation_code: confirmationCode }).fetch().then(user => {
      user.save({ reset_secure_confirmed: 1 }).then(() => {
        res.json({ result: 2, description: 'confirmed request reset password', token: user.get('reset_secure_token') })
      });
    }).catch(
      err => res.status(500).json({ error: 'Invalid confirmation code' })
    );
  },

  ResetSecure: (req, res) => {
    const { type, token, newSecure, cfmSecure } = req.body;
    const { errors, isValid } = validateInput(
      {newSecure, cfmSecure}, ['newSecure', 'cfmSecure']
    );

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      const strMsg = (type === 'PW') ? 'Password' : 'Pin';
      if (err) {
        res.status(401).json({ error: `Reset ${strMsg} process expired, please reprocess again.` })
      } else {
        const userResetSecure = (newSecure) => {
          new User({id: decoded.id}).fetch().then(user => {
            if (user) {
              const fieldUpdate = (type === 'PW')
                ? {password : newSecure, reset_secure_completed: 1}
                : {pin      : newSecure, reset_secure_completed: 1};
              user.save(fieldUpdate).then(userInfo => {
                const jsonUser = { type: strMsg, email: userInfo.get('email'), name: userInfo.get('name') };
                sendResetSecureCompletedEmail(jsonUser);
                res.json({ result: 3, description: `reset ${strMsg} reset_secure_completed` });
              });
            } else {
              res.status(401).json({ error: `Reset ${strMsg} process expired, please reprocess again.` });
            }
          });
        };

        isValid ? userResetSecure(newSecure) : res.status(400).json(errors);
      }
    });
  },

}
