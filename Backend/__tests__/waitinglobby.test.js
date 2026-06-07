// Integration tests for /api/v1/waitinglobby
// Covers the lobby lifecycle the Flutter app depends on: create, fetch, add player, remove player, delete.

const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../index');
const WaitingLobby = require('../models/waitingLobbySchema');
const { connect, disconnect } = require('./helpers/db');

const LOBBY_CODE = 'LOBBY01';

beforeAll(connect);
afterAll(disconnect);

// Start each test with a clean lobby collection.
afterEach(async () => {
  await WaitingLobby.deleteMany({});
});

// --- POST /api/v1/waitinglobby ---

test('creates a lobby and returns 201', async () => {
  const res = await request(app)
    .post('/api/v1/waitinglobby')
    .send({ lobbyCode: LOBBY_CODE, users: ['alice'] });

  expect(res.status).toBe(201);
  expect(res.body.data.lobby.lobbyCode).toBe(LOBBY_CODE);
  expect(res.body.data.lobby.users).toContain('alice');
});

// --- GET /api/v1/waitinglobby/:id ---

test('fetches a lobby by ID and returns 200', async () => {
  const lobby = await WaitingLobby.create({
    lobbyCode: LOBBY_CODE,
    users: ['alice'],
  });

  const res = await request(app).get(`/api/v1/waitinglobby/${lobby._id}`);

  expect(res.status).toBe(200);
  expect(res.body.data.lobby.lobbyCode).toBe(LOBBY_CODE);
});

test('returns 404 for a non-existent lobby ID', async () => {
  // A valid ObjectId that does not exist in the database.
  const fakeId = new mongoose.Types.ObjectId();

  const res = await request(app).get(`/api/v1/waitinglobby/${fakeId}`);

  expect(res.status).toBe(404);
});

// --- POST /api/v1/waitinglobby/:id (add user) ---

test('adds a user to the lobby and returns 201', async () => {
  const lobby = await WaitingLobby.create({
    lobbyCode: LOBBY_CODE,
    users: ['alice'],
  });

  const res = await request(app)
    .post(`/api/v1/waitinglobby/${lobby._id}`)
    .send({ users: 'bob' });

  expect(res.status).toBe(201);
  expect(res.body.data.lobby.users).toContain('bob');
});

// --- DELETE /api/v1/waitinglobby/deleteOneUSer/:id ---

test('removes a specific user from the lobby and returns 204', async () => {
  const lobby = await WaitingLobby.create({
    lobbyCode: LOBBY_CODE,
    users: ['alice', 'bob'],
  });

  const res = await request(app)
    .delete(`/api/v1/waitinglobby/deleteOneUSer/${lobby._id}`)
    .send({ users: 'bob' });

  expect(res.status).toBe(204);

  // Confirm bob was removed but alice remains.
  const updated = await WaitingLobby.findById(lobby._id);
  expect(updated.users).not.toContain('bob');
  expect(updated.users).toContain('alice');
});

// --- DELETE /api/v1/waitinglobby/:id ---

test('deletes the entire lobby and returns 204', async () => {
  const lobby = await WaitingLobby.create({
    lobbyCode: LOBBY_CODE,
    users: ['alice'],
  });

  const res = await request(app).delete(`/api/v1/waitinglobby/${lobby._id}`);

  expect(res.status).toBe(204);

  // Confirm the document is gone from the database.
  const gone = await WaitingLobby.findById(lobby._id);
  expect(gone).toBeNull();
});
