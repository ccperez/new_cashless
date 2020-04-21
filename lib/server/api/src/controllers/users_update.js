import User from '../models/User';
import validateInput from '../shared/validations/common';

const userUpdate = (response, phone, field, value) => {
  User.where({ phone: phone }).fetch().then(user => {
    user.save(field, value).then(() => {
      field = field.charAt(0).toUpperCase() + field.slice(1);
      response.json({ result: 1, description: `${field} successfully update` })
    })
  }).catch(
    err => response.status(500).json({ error: 'Accout not found' })
  )
}

export default {

  updateFullname: (req, res) => {
    const { phone, name } = req.body
    const userInfo = { phone, name };
    const { errors, isValid } = validateInput(userInfo, ['phone', 'name']);

    isValid ? userUpdate(res, phone, 'name', name) : res.status(400).json(errors);
  },

  updatePassword: (req, res) => {
    const { phone, password } = req.body
    const userInfo = { phone, password };
    const { errors, isValid } = validateInput(userInfo, ['phone', 'password']);

    isValid ? userUpdate(res, phone, 'password', password) : res.status(400).json(errors);
  },

  updatePin: (req, res) => {
    const { phone, pin } = req.body
    const userInfo = { phone, pin };
    const { errors, isValid } = validateInput(userInfo, ['phone', 'pin']);

    isValid ? userUpdate(res, phone, 'pin', pin) : res.status(400).json(errors);
  },

}
