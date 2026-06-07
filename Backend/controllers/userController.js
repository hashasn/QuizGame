const catchAsync = require('../util/catchAsync');
const AppError = require('../util/appError');
const User = require('../models/userModel');

const filterObj = (obj, ...allowedFields) => {
  const newObj = {};
  Object.keys(obj).forEach((key) => {
    if (allowedFields.includes(key)) newObj[key] = obj[key];
  });
  return newObj;
};
exports.getAllUsers = catchAsync(async (req, res, next) => {
  const quizes = await User.find();
  res.status(200).json({
    status: 'Success',
    results: quizes.length,
    data: {
      quizes,
    },
  });
});

exports.updateUserDetails = catchAsync(async (req, res, next) => {
  if (req.body.password || req.body.passwordConfirm) {
    return next(
      new AppError('cannot update password here. Got to /updatePassword', 400),
    );
  }

  const filteredBody = filterObj(req.body, 'name', 'email');
  const updatesUser = await User.findByIdAndUpdate(req.user.id, filteredBody, {
    new: true,
    runValidators: true,
  });
  res.status(200).json({ status: 'success', data: updatesUser });
});

exports.deleteUserAccount = catchAsync(async (req, res, next) => {
  await User.findByIdAndUpdate(req.user.id, { active: false });

  res.status(204).json({
    status: 'success',
    data: null,
  });
});

exports.getUser = (req, res) => {
  res.status(500).json({
    status: 'error',
    message: 'This route is not yet defined!',
  });
};
exports.createUser = (req, res) => {
  res.status(500).json({
    status: 'error',
    message: 'This route is not yet defined!',
  });
};
exports.updateUser = (req, res) => {
  res.status(500).json({
    status: 'error',
    message: 'This route is not yet defined!',
  });
};
exports.deleteUser = catchAsync(async (req, res, next) => {
  const quiz = await User.findByIdAndDelete(req.params.id);
  if (!quiz) {
    next(new AppError(`No quiz with that ID`, 404));
  }
  res.status(204).json({ status: 'success' });
});
