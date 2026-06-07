// Quiz catalogue schema — each quiz has a title, an image, and an array of multiple-choice questions.
const mongoose = require('mongoose');

const quizSchema = new mongoose.Schema({
  title: { type: String, required: [true, 'Must have a title'], unique: true },
  image: { type: String },
  questions: {
    type: [
      {
        prompt: { type: String, required: [true, 'Must have promt'] },
        options: { type: [String], required: [true, 'Must have options'] },
        answers: {
          type: String,
          required: [true, 'Must have an answer'],
        },
      },
    ],
  },
});

const quiz = mongoose.model('Quiz', quizSchema);

module.exports = quiz;
