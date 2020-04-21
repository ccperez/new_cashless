import bookshelf from '../bookshelf';
import jwt from 'jsonwebtoken';

import UserLoadDetail from './UserLoadDetail';
import UserPayDetail from './UserPayDetail';
import UserLoadTransferDetail from './UserLoadTransferDetail';

const { HOST, JWT_SECRET } = process.env;

export default bookshelf.Model.extend({
  tableName: 'users',

  loadDetail: function() {
    return this.hasMany('UserLoadDetail')
  },

  payDetail: function() {
    return this.hasMany('UserPayDetail')
  },

  loadTransferDetail: function() {
    return this.hasMany('UserLoadTransferDetail')
  },

  isPasswordMatch: function(password) {
    return password === this.get('password');
  },

  isConfirmed: function() {
    return this.get('confirm')
  },

  isResetSecureConfirmed: function() {
    return this.get('reset_secure_confirmed')
  },

  isResetSecureCompleted: function() {
    return this.get('reset_secure_completed')
  },

  generateResetSecureToken: function() {
    const token = jwt.sign({id: this.get('id')}, JWT_SECRET, {expiresIn: "3m"});
    this.set('reset_secure_token', token);
    this.set('reset_secure_confirmed', 0);
    this.set('reset_secure_completed', 0);
    this.save();
    return token;
  },

  generateConfirmationCode: function() {
    const token = this.generateResetSecureToken();
    const confirmationCode = token.slice(token.length-8);
    this.set('reset_secure_confirmation_code', confirmationCode);
    this.save();
    return confirmationCode;
  },

});
