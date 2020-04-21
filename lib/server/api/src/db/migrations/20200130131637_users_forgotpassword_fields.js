
exports.up = function(knex) {
  return knex.schema.table('users', function(table) {
    table.string('reset_password_token');
    table.string('reset_password_confirmation_code');
    table.integer('reset_password_confirmed').defaultTo(0);
    table.integer('reset_password_completed').defaultTo(0);
  })
};

exports.down = function(knex) {
  return knex.schema.table('users', function(table) {
    table.dropColumn('reset_password_token');
    table.dropColumn('reset_password_confirmation_code');
    table.dropColumn('reset_password_confirmed');
    table.dropColumn('reset_password_completed');
  })
};
