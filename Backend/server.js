const ws = require('ws');
const dotenv = require('dotenv');
const mongoose = require('mongoose');
//const changeStream = require('./util/onchange');
const waitingLobby = require('./models/waitingLobbySchema');
const gameModel = require('./models/gameSchema');

process.on('uncaughtException', (err) => {
  console.log('UNCAUGHT EXCEPTION! 💥 Shutting down...');
  console.log(err.name, err.message);
  process.exit(1);
});

const app = require('./index');
const { json } = require('express');

dotenv.config({ path: './config.env' });

const DB = process.env.DATABASE;

mongoose
  .connect(DB, {
    // useNewUrlParser: true,
    // useCreateIndex: true,
    // useFindAndModify: false,
  })
  .then(() => {
    //
    console.log('DB connection established');
  });

// console.log(process.env);
// console.log(app.get('env'));
const port = 2000;
const server = app.listen(port, () => {
  console.log(`app listening on port ${port}....`);
});
const wsServer = new ws.Server({ noServer: true });

server.on('upgrade', (req, socket, head) => {
  wsServer.handleUpgrade(req, socket, head, (ws) => {
    wsServer.emit('connection', ws, req);
  });
});

const startChangeStream = async (ws) => {
  console.log('trying to open change stream');
  // console.log(code);
  // const pipeline = [{ $match: { 'fullDocument.lobbyCode': code } }];
  const changeStream = waitingLobby.watch();

  changeStream.on('change', (change) => {
    console.log('change stream working');
    console.log('Collection changed:', change);
    const { operationType } = change;
    if (operationType === 'insert') {
      const { fullDocument } = change;
      const { _id } = fullDocument;
      console.log(`object string id is ${_id}}`);

      wsServer.clients.forEach((client) => {
        if (client.readyState === ws.OPEN) {
          console.log(JSON.stringify(_id));
          client.send(JSON.stringify(change));
        }
      });
    } else if (operationType === 'update') {
      const { documentKey } = change;
      const { _id } = documentKey;
      wsServer.clients.forEach((client) => {
        if (client.readyState === ws.OPEN) {
          console.log(JSON.stringify(_id));

          client.send(_id.toString());
        }
      });
    } else if (operationType === 'delete') {
      wsServer.clients.forEach((client) => {
        if (client.readyState === ws.OPEN) {
          client.send(JSON.stringify(change));
        }
      });
    }
  });

  changeStream.on('error', (error) => {
    console.error('Change stream error:', error);
  });

  changeStream.on('close', (close) => {
    console.log('Change stream closed:', close);
  });
};

const GameModelChangeStream = async (ws, code) => {
  console.log('trying to open change stream');
  // console.log(code);
  // const pipeline = [{ $match: { 'fullDocument.lobbyCode': code } }];
  if (code === 'game') {
    const changeStream = gameModel.watch();

    changeStream.on('change', (change) => {
      console.log('listening to game model');
      console.log('Collection changed:', change);
      const { operationType } = change;
      if (operationType === 'insert') {
        const { fullDocument } = change;
        const { _id } = fullDocument;
        console.log(`object string id is ${_id}}`);

        wsServer.clients.forEach((client) => {
          if (client.readyState === ws.OPEN) {
            console.log(JSON.stringify(_id));
            client.send(JSON.stringify(change));
          }
        });
      }
    });

    changeStream.on('error', (error) => {
      console.error('Change stream error:', error);
    });

    changeStream.on('close', (close) => {
      console.log('Change stream closed:', close);
    });
  } else {
    console.log('wrong code for game');
  }
};
// const closeAllConnections = () => {
//   wsServer.clients.forEach((client) => {
//     if (client.readyState === ws.OPEN) {
//       console.log('c;ients being vcloeds');
//       client.terminate();
//     }
//   });
// };
wsServer.on('connection', (ws, req) => {
  let code = '';
  console.log('A new client connected');

  ws.on('message', (data) => {
    code = data.toString();
    console.log('received: %s', code);
    GameModelChangeStream(ws, code);
  });

  ws.on('close', () => {
    console.log('Connection closed');
    // closeAllConnections();
  });
  startChangeStream(ws);
});

process.on('unhandledRejection', (err) => {
  console.log('UNHANDLED REJECTION! 💥 Shutting down...');
  console.log(err.name, err.message);
  server.close(() => {
    process.exit(1);
  });
});

module.exports = wsServer;
