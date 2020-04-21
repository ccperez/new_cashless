exports.up = (knex) => {
  return knex.schema.createTable('load_type', (table) => {
    table.increments('id').primary()
    table.string('type')
  }).createTable('load_source', (table) => {
    table.increments('id').primary()
    table.string('source')
  }).createTable('users_load_detail', (table) => {
    table.increments()
    table.string('phone').notNullable()
    table.decimal('amount', 10, 2).defaultTo(0)
    table.integer('type_id').defaultTo(1).references('load_type.id')
    table.integer('source_id').defaultTo(1).references('load_source.id')
    table.string('description')
    table.timestamp('created_at').defaultTo(knex.fn.now())
  })
};

exports.down = (knex) => knex.schema.dropTable('load_type').dropTable('load_source').dropTable('users_load_detail');
