
exports.seed = function(knex) {
  // Deletes ALL existing entries
  return knex('pay_from').del()
    .then(function () {
      // Inserts seed entries
      return knex('pay_from').insert([
        {id: 1, pay: 'BKA-Canteen'},
        {id: 2, pay: 'BKA-School'}
      ]);
    });
};
