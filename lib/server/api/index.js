require('dotenv').config();

import express from 'express';
import path from 'path';
import bodyParser from 'body-parser'

import users from './src/routes/users';

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/api/users', users);

app.get('/*', (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"));
});

const { PORT } = process.env;
app.listen( PORT, () => console.log(`Server listening on: ${PORT}`) );
