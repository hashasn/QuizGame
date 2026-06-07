// Entry point — connects to MongoDB, starts the HTTP server, and opens WebSocket change streams.
// Both MongoDB change streams are opened once after the DB connects and shared across all WebSocket clients.
const ws = require('ws');
const dotenv = require('dotenv');
const mongoose = require('mongoose');
const waitingLobby = require('./models/waitingLobbySchema');
const gameModel = require('./models/gameSchema');

process.on('uncaughtException', (err) => {
  console.log('UNCAUGHT EXCEPTION! Shutting down...');
  console.log(err.name, err.message);
  process.exit(1);
});

const app = require('./index');

dotenv.config({ path: './config.env' });

const DB = process.env.DATABASE;

const broadcast = (wsServer, data) => {
  wsServer.clients.forEach((client) => {
    if (client.readyState === ws.OPEN) {
      client.send(data);
    }
  });
};

// Open both change streams once after DB connects and reuse them for all clients.
const openChangeStreams = (wsServer) => {
  const lobbyStream = waitingLobby.watch();
  lobbyStream.on('change', (change) => {
    const { operationType } = change;
    if (operationType === 'insert') {
      broadcast(wsServer, JSON.stringify(change));
    } else if (operationType === 'update') {
      broadcast(wsServer, change.documentKey._id.toString());
    } else if (operationType === 'delete') {
      broadcast(wsServer, JSON.stringify(change));
    }
  });
  lobbyStream.on('error', (err) =>
    console.error('Lobby change stream error:', err),
  );

  const gameStream = gameModel.watch();
  gameStream.on('change', (change) => {
    const { operationType } = change;
    if (operationType === 'insert' || operationType === 'update') {
      broadcast(wsServer, JSON.stringify(change));
    }
  });
  gameStream.on('error', (err) =>
    console.error('Game change stream error:', err),
  );
};

mongoose.connect(DB).then(() => {
  console.log('DB connection established');

  const port = process.env.PORT || 2000;
  const server = app.listen(port, () => {
    console.log(`App listening on port ${port}`);
  });

  const wsServer = new ws.Server({ noServer: true });

  openChangeStreams(wsServer);

  server.on('upgrade', (req, socket, head) => {
    wsServer.handleUpgrade(req, socket, head, (client) => {
      wsServer.emit('connection', client, req);
    });
  });

  wsServer.on('connection', (socket) => {
    console.log('Client connected');
    socket.on('close', () => console.log('Client disconnected'));
  });

  process.on('unhandledRejection', (err) => {
    console.log('UNHANDLED REJECTION! Shutting down...');
    console.log(err.name, err.message);
    server.close(() => {
      process.exit(1);
    });
  });

  module.exports = wsServer;
});
