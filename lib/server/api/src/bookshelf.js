import knex from 'knex';
import bookshelf from 'bookshelf';
import knexConfig from '../knexfile';

const { NODE_ENV } = process.env;

export default bookshelf(knex(knexConfig[NODE_ENV]));
