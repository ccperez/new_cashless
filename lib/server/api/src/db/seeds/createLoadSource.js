
exports.seed = function(knex) {
  // Deletes ALL existing entries
  return knex('load_source').del()
    .then(function () {
      // Inserts seed entries
      return knex('load_source').insert([
        {id: 1, source: 'BKA-School'},
        {id: 2, source: 'Transfer'}
      ]);
    });
};
