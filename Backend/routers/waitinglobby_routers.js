// Routes for /api/v1/waitinglobby — manages the pre-game lobby player list.
// Note: the /deleteOneUSer/:id path has a capitalisation typo that must be preserved to match the Flutter client.
const express = require('express');
//const quizController = require('../controllers/quizController');
const lobbyController = require('../controllers/waitinglobbyController');
//const authController = require('../controllers/authController');

const Router = express.Router();
//Router.param('id', quizController.checkId);
Router.route('/').get(lobbyController.getAll).post(lobbyController.create);

Router.route('/:id')
  .patch(lobbyController.update)
  .post(lobbyController.addUser)
  .get(lobbyController.getOne)
  .delete(lobbyController.delete);

Router.route('/deleteOneUSer/:id').delete(lobbyController.deleteOneUser);

//Router.route('?').post(lobbyController.createOne);
module.exports = Router;
