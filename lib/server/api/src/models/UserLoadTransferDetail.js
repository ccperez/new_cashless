import bookshelf from '../bookshelf';

export default bookshelf.Model.extend({
  tableName: 'users_load_transfer_detail',

  user() {
    return this.belongsTo('User')
  }
  
});
