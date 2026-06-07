const express = require('express');
const gameController = require('../controllers/gameController');

const Router = express.Router();

Router.route('/')
  .get(gameController.getAll)
  .post(gameController.create)
  .patch(gameController.updateScore)
  .delete(gameController.delete);

Router.route('/:id').get(gameController.getOne);

module.exports = Router;
