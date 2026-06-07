const mongoose = require('mongoose');
const quiz = require('./quizSchema');

const gameSchema = new mongoose.Schema({
  gameCode: { type: String, required: [true, 'Must have a lobby code'] },
  quiz: {
    type: mongoose.Schema.ObjectId,
    ref: quiz,
    required: [true, 'Must have a a quiz'],
  },
  users: {
    type: [{ name: { type: String }, score: { type: String } }],
    required: [true, 'Must have a user'],
  },
});

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
