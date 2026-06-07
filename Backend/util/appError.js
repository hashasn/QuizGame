// Operational error class — marks errors that are expected (bad input, not found, etc.)
// so the global error handler can distinguish them from unexpected programming errors.
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
