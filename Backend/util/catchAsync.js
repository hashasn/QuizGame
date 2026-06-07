// Wraps async route handlers so any rejected promise is forwarded to Express's
// global error handler via next(err), removing the need for try/catch in every controller.
module.exports = (fn) => {
  return (req, res, next) => {
    fn(req, res, next).catch(next);
  };
};
