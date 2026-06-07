const express = require('express');
const userController = require('../controllers/userController');
const authController = require('../controllers/authContoller');

const router = express.Router();

router.post('/signUp', authController.signUp);
router.post('/login', authController.login);

router.post('/forgotPassword', authController.forgotPassword);
router.patch('/resetPassword/:token', authController.resetPassword);
router.patch(
  '/updatePassword',
  authController.protect,
  authController.updatePassword,
);
router.delete(
  '/deleteAccount',
  authController.protect,
  userController.deleteUserAcxount,
);
router.patch(
  '/updateMe',
  authController.protect,
  userController.updateUserDetails,
);
router
  .route('/')
  .get(userController.getAllUsers)
  .post(userController.createUser);

router
  .route('/:id')
  .get(userController.getUser)
  .patch(userController.updateUser)
  .delete(
    authController.protect,
    authController.restrictTo('admin'),
    userController.deleteUser,
  );

module.exports = router;
