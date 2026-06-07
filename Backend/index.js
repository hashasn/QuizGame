// Express app setup — applies security middleware (helmet, rate limiting, sanitisation) and mounts all routers.
// Exported without starting a server so it can be imported directly in integration tests.
const express = require('express');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');
const mongoSanitize = require('express-mongo-sanitize');
const xss = require('xss-clean');
const quizeRouter = require('./routers/quiz_routers');
const userRouter = require('./routers/user_routers');
const waitingRouter = require('./routers/waitinglobby_routers');
const gameRouter = require('./routers/game_router');
const globalErrorHandler = require('./controllers/errorController');
const AppError = require('./util/appError');

const app = express();

app.use(helmet());
const limiter = rateLimit({
  max: 100,
  windowMs: 60 * 60 * 1000,
  message: 'Too many requests from this IP, try again in an hour',
});
app.use(compression());
app.use('/api', limiter);
app.use(express.json({ limit: '10kb' }));
app.use(mongoSanitize());
app.use(xss());

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
