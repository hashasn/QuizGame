const express = require('express');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');
const quizeRouter = require('./routers/quiz_routers');
const userRouter = require('./routers/user_routers');
const waitingRouter = require('./routers/waitinglobby_routers');
const gameRouter = require('./routers/game_router');
const globalErrorHandler = require('./controllers/errorController');
const AppError = require('./util/appEroor');

const app = express();

//app.use(helmet());
const limiter = rateLimit({
  max: 100,
  windiwMs: 60 * 60 * 1000,
  message: 'too many requests from this IP, try again in a hour',
});
app.use(compression());
app.use('/api', limiter);
app.use(express.json());

app.use('/api/v1/quizes', quizeRouter);
app.use('/api/v1/users', userRouter);
app.use('/api/v1/waitinglobby', waitingRouter);
app.use('/api/v1/game', gameRouter);

app.all('*', (req, res, next) => {
  // const error = new Error(`cant find ${req.originalUrl} on this server`);
  //   error.status = 'fail';
  //   error.statusCode = 404;
  next(new AppError(`cant find ${req.originalUrl} on this server`, 404));
});

app.use(globalErrorHandler);

module.exports = app;
