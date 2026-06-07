// Integration tests for /api/v1/game
// Covers the four endpoints the Flutter app relies on: create, fetch, update score, delete.
// A real Quiz document is seeded before the suite so the game's required quiz reference resolves.

const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../index');
const Quiz = require('../models/quizSchema');
const Game = require('../models/gameSchema');
const { connect, disconnect } = require('./helpers/db');

const GAME_CODE = 'TEST01';

// Minimal quiz document — satisfies the quiz field reference on the game schema.
const TEST_QUIZ = {
  title: 'Integration Test Quiz',
  image: 'test.png',
  questions: [
    { prompt: 'What is 2+2?', options: ['2', '3', '4', '5'], answers: '4' },
  ],
};

// Builds a valid game body from a quiz ObjectId.
const gameBody = (quizId) => ({
  gameCode: GAME_CODE,
  quiz: quizId,
  time: 30,
  users: [{ name: 'alice', score: '0', complete: false }],
});

let quizId;

beforeAll(async () => {
  await connect();
  const quiz = await Quiz.create(TEST_QUIZ);
  quizId = quiz._id;
});

afterAll(disconnect);

// Remove all games after each test so each one starts from a clean state.
// The quiz is kept because it is needed by every test.
afterEach(async () => {
  await Game.deleteMany({});
});

// --- POST /api/v1/game ---

test('creates a game and returns 201', async () => {
  const res = await request(app).post('/api/v1/game').send(gameBody(quizId));

  expect(res.status).toBe(201);
  expect(res.body.data.game.gameCode).toBe(GAME_CODE);
  expect(res.body.data.game.users).toHaveLength(1);
});

test('returns an error when required fields are missing', async () => {
  // Sending a body with no quiz or users — mongoose validation should reject it.
  const res = await request(app)
    .post('/api/v1/game')
    .send({ gameCode: GAME_CODE });

  expect(res.status).toBeGreaterThanOrEqual(400);
});

// --- GET /api/v1/game?gameCode= ---

test('fetches a game by gameCode and returns 200', async () => {
  await Game.create(gameBody(quizId));

  const res = await request(app).get(`/api/v1/game?gameCode=${GAME_CODE}`);

  expect(res.status).toBe(200);
  expect(res.body.data.finalGame.gameCode).toBe(GAME_CODE);
});

// --- PATCH /api/v1/game?gameCode= ---

test('updates a player score and returns 200', async () => {
  await Game.create(gameBody(quizId));

  const res = await request(app)
    .patch(`/api/v1/game?gameCode=${GAME_CODE}`)
    .send({ name: 'alice', score: '5' });

  expect(res.status).toBe(200);
  const alice = res.body.data.game.users.find((u) => u.name === 'alice');
  expect(alice.score).toBe('5');
});

// --- DELETE /api/v1/game?gameCode= ---

test('deletes a game and returns 204', async () => {
  await Game.create(gameBody(quizId));

  const res = await request(app).delete(`/api/v1/game?gameCode=${GAME_CODE}`);

  expect(res.status).toBe(204);

  // Confirm the document is gone from the database.
  const gone = await Game.findOne({ gameCode: GAME_CODE });
  expect(gone).toBeNull();
});
