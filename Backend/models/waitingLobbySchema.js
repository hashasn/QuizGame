// Waiting lobby schema — holds a lobby code and the list of player names before the game starts.
const mongoose = require('mongoose');

const waitingLobbySchema = new mongoose.Schema({
  lobbyCode: { type: String, required: [true, 'Must have a lobby code'] },
  users: { type: [String], required: [true, 'Must have a user'] },
});

const waitingLobby = mongoose.model('waitingLobby', waitingLobbySchema);

module.exports = waitingLobby;
