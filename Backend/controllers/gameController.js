// CRUD controller for the game collection — handles game creation, score updates, and cleanup.
const catchAsync = require('../util/catchAsync');
const AppError = require('../util/appError');
const gameModel = require('../models/gameSchema');

exports.getAll = catchAsync(async (req, res, next) => {
  const game = await gameModel.find({ gameCode: req.query.gameCode });

  const finalGame = game[0];

  finalGame.users.sort((a, b) => b.score - a.score);

  res.status(200).json({
    status: 'Success',
    results: game.length,
    data: {
      finalGame,
    },
  });
});

exports.getOne = catchAsync(async (req, res, next) => {
  const game = await gameModel.findById(req.params.id);
  if (!game) {
    return next(new AppError(`No game with that ID`, 404));
  }
  res.status(200).json({
    status: 'Success',

    data: {
      game,
    },
  });
});

exports.create = catchAsync(async (req, res, next) => {
  const game = await gameModel.create(req.body);
  res.status(201).json({
    status: 'success',
    data: {
      game,
    },
  });
});

exports.updateScore = catchAsync(async (req, res, next) => {
  const game = await gameModel.findOne({ gameCode: req.query.gameCode });

  const { name, score, complete } = req.body;

  for (let i = 0; i < game.users.length; i++) {
    if (game.users[i].name === name) {
      game.users[i].score = score;
      if (complete !== undefined) game.users[i].complete = complete;
    }
  }

  await game.save();

  res.status(200).json({
    status: 'success',
    data: {
      game,
    },
  });
});

exports.delete = catchAsync(async (req, res, next) => {
  await gameModel.findOneAndDelete({ gameCode: req.query.gameCode });

  res.status(204).json({ status: 'success' });
});
