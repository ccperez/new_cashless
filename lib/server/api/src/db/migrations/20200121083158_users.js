exports.up = (knex) => {
  return knex.schema.createTable('users', (table) => {
    table.increments();
    table.string('phone').notNullable().unique();
    table.string('studentId').notNullable();
    table.string('name').notNullable();
    table.string('email').notNullable();
    table.string('password').notNullable();
    table.string('pin').notNullable();
    table.integer('confirm').defaultTo(0);
    table.timestamps();
  });
};

exports.down = (knex) => knex.schema.dropTable('users');
