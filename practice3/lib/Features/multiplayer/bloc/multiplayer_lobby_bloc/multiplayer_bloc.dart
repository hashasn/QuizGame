import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';
import 'package:footy/features/multiplayer/business/usecase/get_lobby_users.dart';
import 'package:footy/features/multiplayer/data/MOdels/game_model.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/core/Websocket/websocket.dart';
import 'package:footy/features/multiplayer/business/usecase/get_quizzes.dart';
import 'package:footy/features/multiplayer/data/backend/add_game.dart';
import 'package:footy/features/multiplayer/data/backend/add_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'multiplayer_event.dart';
part 'multiplayer_state.dart';

class MultiplayerBloc extends Bloc<MultiplayerEvent, MultiplayerState> {
  final GetPlayers usecase;
  final GetQuizzesForMultiplayer getQuizUsecase;
  final WebSocket socket = WebSocket();

  String name = '';
  String code = '';
  String userName = '';
  int count = 0;

  MultiplayerBloc(this.usecase, this.getQuizUsecase)
      : super(MultiplayerInitial()) {
    socket.connect();

    socket.getMessageStream().listen(
      (event) async {
        // print('Received message: $event');

        if (event != null) {
          if (event is String && event.contains('fullDocument')) {
            //Listen for insert change
            String coll = json.decode(event)['ns']['coll'];
            if (coll == 'waitinglobbies') {
              //if change is in waitinglobbies collection
              String id = json.decode(event)['fullDocument']['_id'];
              String lobbyCode =
                  json.decode(event)['fullDocument']['lobbyCode'];
              if (lobbyCode == code) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setString('lobbyID', id);

                add(LobbychangedEvent());
              }
            }
          } else {
            //Listen for update change

            print('current id is $event');
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString('lobbyID', event);

            add(LobbychangedEvent());
          }
        }
      },
      onDone: () {
        print('WebSocket connection closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
    on<LobbyInitialEvent>(lobbyInitialEvent);
    //on<LobbyNewPlayerInitialEvent>(lobbyNewPlayerInitialEvent);
    on<LobbychangedEvent>(lobbyChangedEvent);
    //  on<PlayerLeftEvent>(playerLeftEvent);
    on<LeaveGameEvent>(leaveGameEvent);
    on<StartGameEvent>(startGameEvent);
  }

  FutureOr<void> lobbyInitialEvent(
      LobbyInitialEvent event, Emitter<MultiplayerState> emit) async {
    print(' am back here');
    emit(LobbyLoadingstate(loadingString: 'joining Lobby.....'));
    await Future.delayed(Duration(seconds: 1));
    name = event.name;
    code = event.code;
    userName = '$name${randomNum()}';
    AddUsers user = AddUsers(name: name, code: code, userName: userName);
    user.addUsers();
    // await Future.delayed(Duration(seconds: 1));
    // String id = await user.getId();

    //socket.sendMessage(code);

    await Future.delayed(Duration(seconds: 5));

    // final players = await fetchPlayer();
    // players.fold(
    //   (left) =>
    //       emit(const LobbyErrorState(error: 'Failed to Success state start')),
    //   (right) => emit(SuccessState(players: right)),
    // );
  }

  // fetchPlayer() async {
  //   return await usecase();
  // }

  FutureOr<void> lobbyChangedEvent(
      LobbychangedEvent event, Emitter<MultiplayerState> emit) async {
    bool gotQuizzes = false;
    late Quizzes newQuiz;
    final quizzes = await getQuizUsecase();
    final newPlayers = await usecase();

    quizzes.fold((l) => gotQuizzes = true, (r) => newQuiz = r);
    if (!gotQuizzes) {
      newPlayers.fold(
        (left) =>
            emit(const LobbyErrorState(error: 'Failed to  change state start')),
        (right) => emit(LobbyChangedstate(newPlayers: right, quizzes: newQuiz)),
      );
    } else {
      emit(const LobbyErrorState(error: 'Server Failure'));
    }
  }

  FutureOr<void> leaveGameEvent(
      LeaveGameEvent event, Emitter<MultiplayerState> emit) {
    emit(LobbyLoadingstate(loadingString: 'Leaving game.....'));
    Future.delayed(Duration(seconds: 1));
    AddUsers user = AddUsers(name: name, code: code, userName: userName);
    user.deleteAllUsers();
    emit(LeaveGameActionState());
  }

  @override
  Future<void> close() {
    socket.closeConnection();
    return super.close();
  }

  FutureOr<void> startGameEvent(
      StartGameEvent event, Emitter<MultiplayerState> emit) {
    int time = int.parse(event.time);
    List<User> users = [];
    for (int i = 0; i < event.players.users.length; i++) {
      users
          .add(User(name: event.players.users[i], score: '0', complete: false));
    }
    CreateGame game = CreateGame(
        quizId: event.id, players: users, gameCode: code, time: time);
    print('game id is ${event.id}');

    game.AddGame();

    socket.closeConnection();
    count++;

    emit(StartGameActionState(username: userName, time: time, count: count));
  }
}

int randomNum() {
  var rng = Random();

  return rng.nextInt(100);
}
