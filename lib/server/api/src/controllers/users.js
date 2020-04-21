import User from '../models/User';
import validateInput from '../shared/validations/common';

export default {

  signUp: (req, res) => {
    const { phone, studentId, name, email, password, pin } = req.body;
    const userInfo = {phone, studentId, name, email, password, pin};
    const { errors, isValid } = validateInput(
      userInfo, ['phone','studentId','name','email','password','pin']
    );

    const userSignUp = (userInfo) => {
      User.forge({ phone: phone }).fetch().then(user => {
        if (user) {
          if (user.isConfirmed()) {
            res.json({ result: 1, description: 'account exist, already confirmed' });
          } else {
            user.save(userInfo).then(() => {
              res.json({ result: 3, description: 'account exist, not yet confirmed' });
            });
          }
        }
      }).catch(() => {
          User.forge(userInfo, { hasTimestamps: true }).save().then(() => {
            // res.json({ user: userInfo });
            res.json({ result: 2, description: 'account created, successfully' });
          }).catch(
            err => res.status(500).json({ error: err })
          );
        }
      )
    };

    isValid ? userSignUp(userInfo) : res.status(400).json(errors);
  },

  confirmed: (req, res) => {
    const phone = req.body.phone;
    User.where({ phone: phone }).fetch().then(user => {
      user.save({confirm: 1}).then(
        () => res.json({ result: 1, description: 'successfully confirmed' })
      );
    }).catch(
      err => res.status(500).json({ error: 'No account found' })
    );
  },

  signIn: (req, res) => {
    const { phone, password } = req.body;
    const userInfo = { phone, password };
    const { errors, isValid } = validateInput(userInfo, ['phone', 'password']);

    const userSignIn = (phone, password) => {
      new User({ phone: phone }).fetch().then(user => {
        if (user && user.isPasswordMatch(password)) {
          if (user.isConfirmed()) {
            res.json({ result: 1, description: 'login successfully' });
          } else {
            res.json({ result: 3, description: 'account exist, not yet confirmed' });
          }
        } else {
          res.status(400).json({ error: 'Invalid credentials' });
        }
      }).catch(
        err => res.status(500).json({ error: 'No account found' })
      );
    };

    isValid ? userSignIn(phone, password) : res.status(400).json(errors);
  },

}
