import bookshelf from '../bookshelf';
import User from './User';

export default bookshelf.Model.extend({
  tableName: 'users_load_detail',

  user() {
    return this.belongsTo('User')
  }

});
