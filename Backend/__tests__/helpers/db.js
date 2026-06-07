// Shared in-memory MongoDB lifecycle used by all test files.
// Each test file calls connect() in beforeAll and disconnect() in afterAll.
// --runInBand ensures test files run serially so the single mongoose connection
// is cleanly handed off between files.

const { MongoMemoryServer } = require('mongodb-memory-server');
const mongoose = require('mongoose');

let mongod;

// Start an in-memory MongoDB server and open a mongoose connection.
const connect = async () => {
  mongod = await MongoMemoryServer.create();
  await mongoose.connect(mongod.getUri());
};

// Close the mongoose connection and stop the in-memory server.
const disconnect = async () => {
  await mongoose.disconnect();
  await mongod.stop();
};

module.exports = { connect, disconnect };
