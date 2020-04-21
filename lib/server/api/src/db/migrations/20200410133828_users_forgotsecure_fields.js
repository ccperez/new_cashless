
exports.up = function(knex) {
  return knex.schema.table('users', function(table) {
    table.dropColumn('reset_password_token');
    table.dropColumn('reset_password_confirmation_code');
    table.dropColumn('reset_password_confirmed');
    table.dropColumn('reset_password_completed');

    table.string('reset_secure_token');
    table.string('reset_secure_confirmation_code');
    table.integer('reset_secure_confirmed').defaultTo(0);
    table.integer('reset_secure_completed').defaultTo(0);
  })
};

exports.down = function(knex) {
  return knex.schema.table('users', function(table) {
    table.dropColumn('reset_secure_token');
    table.dropColumn('reset_secure_confirmation_code');
    table.dropColumn('reset_secure_confirmed');
    table.dropColumn('reset_secure_completed');

    table.string('reset_password_token');
    table.string('reset_password_confirmation_code');
    table.integer('reset_password_confirmed').defaultTo(0);
    table.integer('reset_password_completed').defaultTo(0);
  })
};
