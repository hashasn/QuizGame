//const fs = require('fs');
const Quiz = require('../models/quizSchema');
const catchAsync = require('../util/catchAsync');
const AppError = require('../util/appEroor');
// const quizes = JSON.parse(
//   fs.readFileSync(`${__dirname}/../data/quiz_data.json`),
// );

// exports.checkBody = (req, res, next) => {
//   if (!req.body.title) {
//     return res.status(400).json({ status: 'fail', message: 'missing title' });
//   }
//   next();
// };

exports.getAll = catchAsync(async (req, res, next) => {
  const quizes = await Quiz.find();
  res.status(200).json({
    status: 'Success',
    results: quizes.length,
    data: {
      quizes,
    },
  });
});

exports.getOne = catchAsync(async (req, res, next) => {
  //const id = req.params.id * 1;

  const quiz = await Quiz.findById(req.params.id);

  if (!quiz) {
    next(new AppError(`No quiz with that ID`, 404));
  }

  //const quiz = quizes.find((el) => el.id === id);

  res.status(200).json({
    status: 'Success',

    data: {
      quiz,
    },
  });
});

exports.createQuiz = catchAsync(async (req, res, next) => {
  // console.log(req.body);

  const quiz = await Quiz.create(req.body);
  res.status(201).json({
    status: 'success',
    data: {
      quiz: quiz,
    },
  });
});

exports.updateQuiz = catchAsync(async (req, res, next) => {
  const quiz = await Quiz.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  });

  if (!quiz) {
    next(new AppError(`No quiz with that ID`, 404));
  }
  res.status(200).json({ status: 'success', data: { quiz } });
});

exports.delete = catchAsync(async (req, res, next) => {
  const quiz = await Quiz.findByIdAndDelete(req.params.id);
  if (!quiz) {
    next(new AppError(`No quiz with that ID`, 404));
  }
  res.status(204).json({ status: 'success' });
});

exports.createQuiz = catchAsync(async (req, res, next) => {
  // console.log(req.body);

  const quiz = await Quiz.create(req.body);
  res.status(201).json({
    status: 'success',
    data: {
      quiz: quiz,
    },
  });
});

exports.createQuizQuestion = catchAsync(async (req, res, next) => {
  const quizId = req.params.id;
  const newQuestion = req.body; // Assuming the request body contains the new question data

  const quiz = await Quiz.findById(quizId);

  if (!quiz) {
    return res.status(404).json({
      status: 'fail',
      message: 'Quiz not found',
    });
  }

  // Assuming the "questions" field is an array within the quiz document
  quiz.questions.push(newQuestion);
  await quiz.save();

  res.status(201).json({
    status: 'success',
    data: {
      quiz: quiz,
    },
  });
});
