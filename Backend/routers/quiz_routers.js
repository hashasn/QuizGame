//const fs = require('fs');
const express = require('express');
const quizController = require('../controllers/quizController');
const authController = require('../controllers/authContoller');

const Router = express.Router();
//Router.param('id', quizController.checkId);
Router.route('/').get(quizController.getAll).post(quizController.createQuiz);

Router.route('/:id')
  .get(quizController.getOne)
  .patch(quizController.updateQuiz)
  .delete(quizController.delete)
  .post(quizController.createQuizQuestion);

module.exports = Router;
