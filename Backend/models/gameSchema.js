// Game session schema — links a lobby code, a quiz, a time limit, and the list of players with their scores.
const mongoose = require('mongoose');
const quiz = require('./quizSchema');

const gameSchema = new mongoose.Schema({
  gameCode: { type: String, required: [true, 'Must have a lobby code'] },
  quiz: {
    type: mongoose.Schema.ObjectId,
    ref: quiz,
    required: [true, 'Must have a quiz'],
  },
  time: { type: Number, default: 30 },
  users: {
    type: [
      {
        name: { type: String },
        score: { type: String },
        complete: { type: Boolean, default: false },
      },
    ],
    required: [true, 'Must have a user'],
  },
});

// Auto-populate the quiz document on every find so callers always get full question data.
gameSchema.pre(/^find/, function (next) {
  this.populate({ path: 'quiz' });

  next();
});

// gameSchema.pre(/^find/, function (next) {
//   this.aggregate([
//     {
//       $unwind: '$users',
//     },
//     {
//       $sort: { 'users.score': 1 },
//     },
//   ]);
//   next();
// });

const game = mongoose.model('gameSchema', gameSchema);

module.exports = game;
