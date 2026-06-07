// Legacy change stream helper — superseded by openChangeStreams() in server.js,
// which opens both lobby and game streams once at startup rather than per connection.
const WebSocket = require('ws');
const waitingLobby = require('../models/waitingLobbySchema');
const wsServer = require('../server');

exports.startChangeStream = () => {
  const changeStream = waitingLobby.watch();

  changeStream.on('change', (change) => {
    console.log('Collection changed:', change);

    // Broadcast the change to all connected WebSocket clients
    wsServer.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(change));
      }
    });
  });

  //   changeStream.on('error', (error) => {
  //     console.error('Change stream error:', error);
  //   });

  //   changeStream.on('close', () => {
  //     console.log('Change stream closed');
  //   });
};
