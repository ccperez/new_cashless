exports.up = (knex) => {
  return knex.schema.createTable('pay_from', (table) => {
    table.increments('id').primary()
    table.string('pay')
  }).createTable('users_pay_detail', (table) => {
    table.increments()
    table.string('phone').notNullable()
    table.decimal('amount', 10, 2).defaultTo(0)
    table.integer('type_id').defaultTo(1).references('load_type.id')
    table.integer('pay_id').references('pay_from.id')
    table.string('description')
    table.timestamp('created_at').defaultTo(knex.fn.now())
    table.integer('collected').defaultTo(0)
    table.timestamp('collected_at')
  })
};

exports.down = (knex) => knex.schema.dropTable('pay_from').dropTable('users_pay_detail');
