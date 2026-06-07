const catchAsync = require('../util/catchAsync');
const AppError = require('../util/appEroor');

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
  const lobby = await waitingLobby.findByIdAndUpdate(req.params.id);
  if (!lobby) {
    return next(new AppError(`No quiz with that ID`, 404));
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

  //console.log(req.body);
  // console.log(lobby.users);
  const index = lobby.users.indexOf(req.body.users);
  ///console.log(index);

  lobby.users.splice(index, 1);

  lobby.save();

  //console.log('deleted One user');
  res.status(204).json({ status: 'success' });
});
