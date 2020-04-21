import bookshelf from '../bookshelf';
import User from './User';

export default bookshelf.Model.extend({
  tableName: 'users_pay_detail',

  user() {
    return this.belongsTo('User')
  }

});
