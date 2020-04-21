exports.seed = function(knex) {
  // Deletes ALL existing entries
  return knex('load_type').del()
    .then(function () {
      // Inserts seed entries
      return knex('load_type').insert([
        {id: 1, type: 'Allowance'},
        {id: 2, type: 'Tuition'}
      ]);
    });
};
