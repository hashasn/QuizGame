class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    console.log(`here is error ${message}`);
    this.statusCode = statusCode;
    //this.status = `${this.statusCode}`.startsWith('4') ? 'fail' : 'error';
    this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

module.exports = AppError;
