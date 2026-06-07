const fs = require('fs');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Quiz = require('../models/quizSchema');
dotenv.config({ path: './config.env' });

const DB = process.env.DATABASE;

mongoose
  .connect(DB, {
    // useNewUrlParser: true,
    // useCreateIndex: true,
    // useFindAndModify: false,
  })
  .then(() => {
    console.log('DB connection established');
  });
//read json file
const quizzes = JSON.parse(
  fs.readFileSync(`${__dirname}/quiz_data.json`, 'utf8'),
);

const importData = async () => {
  try {
    await Quiz.create(quizzes);
    console.log('data imported');
    process.exit();
  } catch (err) {
    console.log(err);
    process.exit();
  }
};

//Delete all data from collection
const deleteData = async () => {
  try {
    await Quiz.deleteMany();
    console.log('data deleted successfully');
    process.exit();
  } catch (err) {
    console.log(err);
    process.exit();
  }
};

if (process.argv[2] === '--import') {
  importData();
} else if (process.argv[2] === '--delete') {
  deleteData();
}

console.log(process.argv);
