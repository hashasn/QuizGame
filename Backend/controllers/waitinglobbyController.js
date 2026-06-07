// CRUD controller for the waiting lobby — manages the player list before a game starts.
const catchAsync = require('../util/catchAsync');
const AppError = require('../util/appError');

const waitingLobby = require('../models/waitingLobbySchema');

exports.getAll = catchAsync(async (req, res, next) => {
  const lobby = await waitingLobby.find(req.query);

  res.status(200).json({
    status: 'Success',
    results: lobby.length,
    data: {
      lobby: lobby,
    },
  });
});

exports.getOne = catchAsync(async (req, res, next) => {
  const lobby = await waitingLobby.findById(req.params.id);
  if (!lobby) {
    return next(new AppError(`No quiz with that ID`, 404));
  }
  res.status(200).json({
    status: 'Success',

    data: {
      lobby: lobby,
    },
  });
});

exports.create = catchAsync(async (req, res, next) => {
  const lobby = await waitingLobby.create(req.body);
  res.status(201).json({
    status: 'success',
    data: {
      lobby: lobby,
    },
  });
});

exports.update = catchAsync(async (req, res, next) => {
  const lobby = await waitingLobby.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  });
  if (!lobby) {
    return next(new AppError(`No lobby with that ID`, 404));
  }
  res.status(200).json({ status: 'success', data: { lobby } });
});

exports.addUser = catchAsync(async (req, res, next) => {
  const newUser = req.body.users;
  // console.log(newUser);

  const lobby = await waitingLobby.findById(req.params.id);
  if (!lobby) {
    // console.log('lobby not found');
    return next(new AppError(`No quiz with that ID`, 404));
  }

  lobby.users.push(newUser);

  await lobby.save();

  res.status(201).json({
    status: 'success',
    data: {
      lobby,
    },
  });
});

exports.delete = catchAsync(async (req, res, next) => {
  const lobby = await waitingLobby.findByIdAndDelete(req.params.id);

  if (!lobby) {
    return next(new AppError(`No quiz with that ID`, 404));
  }

  res.status(204).json({ status: 'success' });
});

exports.deleteOneUser = catchAsync(async (req, res, next) => {
  const lobby = await waitingLobby.findById(req.params.id);

  if (!lobby) {
    return next(new AppError(`No quiz with that ID`, 404));
  }

  const index = lobby.users.indexOf(req.body.users);
  if (index === -1) {
    return next(new AppError(`User not found in lobby`, 404));
  }
  lobby.users.splice(index, 1);

  lobby.save();

  //console.log('deleted One user');
  res.status(204).json({ status: 'success' });
});
