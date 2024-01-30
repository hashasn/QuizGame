import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:footy/features/multiplayer/business/usecase/get_lobby_users.dart';
import 'package:footy/features/multiplayer/data/MOdels/waiting_lobby_users_model.dart';
import 'package:footy/core/Websocket/websocket.dart';
import 'package:footy/features/multiplayer/data/backend/add_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'join_lobby_event.dart';
part 'join_lobby_state.dart';

class JoinLobbyBloc extends Bloc<JoinLobbyEvent, JoinLobbyState> {
  final GetPlayers getUsers;
  WebSocket socket = WebSocket();
  String name = '';
  String code = '';
  String userName = '';
  JoinLobbyBloc(this.getUsers) : super(JoinLobbyInitial()) {
    socket.connect();

    socket.getMessageStream().listen(
      (event) async {
        // print('Received message: $event');

        if (event != null) {
          if (event is String && event.contains('operationType')) {
            String coll = json.decode(event)['ns']['coll'];
            if (coll == 'waitinglobbies') {
              String type = json.decode(event)['operationType'];
              if (type == 'delete') {
                add(JoinLobbyHostLeftGameEvent());
              } else if (type == 'delete') {}
            } else {
              String gameCode = json.decode(event)['fullDocument']['gameCode'];
              if (gameCode == code) {
                add(JoinLobbyGameStartEvent());
              }
            }
            // String id = json.decode(event)['documentKey']['_id'];s
            // String lobbyCode = json.decode(event)['documentKey']['lobbyCode'];
          } else {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString('lobbyID', event);
            print('current id is $event');
            add(JoinLobbyChangedEvent());
          }
        }
      },
    );

    on<JoinLobbyInitialEvent>(joinLobbyInitialEvent);
    on<JoinLobbyChangedEvent>(joinLobbyChangedEvent);
    on<JoinPlayerLeftEvent>(joinPlayerLeftEvent);
    on<JoinLobbyHostLeftGameEvent>(joinLobbyHostLeftGameEvent);
    on<JoinLobbyGameStartEvent>(joinLobbyGameStartEvent);
  }

  FutureOr<void> joinLobbyInitialEvent(
      JoinLobbyInitialEvent event, Emitter<JoinLobbyState> emit) async {
    emit(const JoinLobbyLoadingState(loadingString: 'Joining game....'));
    await Future.delayed(Duration(seconds: 1));
    name = event.name;
    code = event.code;
    userName = '$name${randomNum()}';
    AddUsers users = AddUsers(name: name, code: code, userName: userName);
    String validate = await users.addNewUser();
    if (validate == 'empty') {
      emit(JoinLobbyLoadingState(
          loadingString: 'GameCOde does not exist......'));
      await Future.delayed(Duration(seconds: 3));
      emit(JoinLobbyLeaveGameState());
    }

    socket.sendMessage(code);
    Future.delayed(Duration(seconds: 3));
  }

  FutureOr<void> joinLobbyChangedEvent(
      JoinLobbyChangedEvent event, Emitter<JoinLobbyState> emit) async {
    final newPlayers = await getUsers();

    newPlayers.fold(
      (left) => emit(JoinLobbyErrorState(error: 'Failed to start')),
      (right) => emit(JoinLobbyChangedState(newPlayers: right)),
    );
  }

  FutureOr<void> joinPlayerLeftEvent(
      JoinPlayerLeftEvent event, Emitter<JoinLobbyState> emit) async {
    emit(const JoinLobbyLoadingState(loadingString: 'Leaving Game......'));
    await Future.delayed(Duration(seconds: 1));
    AddUsers users = AddUsers(name: name, code: code, userName: userName);
    users.deleteUser();
    //await Future.delayed(Duration(seconds: 1));

    emit(JoinLobbyLeaveGameState());
  }

  FutureOr<void> joinLobbyHostLeftGameEvent(
      JoinLobbyHostLeftGameEvent event, Emitter<JoinLobbyState> emit) async {
    emit(const JoinLobbyLoadingState(loadingString: "Host Ended Game...."));
    await Future.delayed(Duration(seconds: 1));
    emit(const JoinLobbyLoadingState(loadingString: "Leaving Game ......."));
    await Future.delayed(Duration(seconds: 1));
    emit(JoinLobbyLeaveGameState());
  }

  @override
  Future<void> close() {
    socket.closeConnection();
    return super.close();
  }

  FutureOr<void> joinLobbyGameStartEvent(
      JoinLobbyGameStartEvent event, Emitter<JoinLobbyState> emit) {
    emit(JoinLobbyGameStartActionState(username: userName));
  }
}

int randomNum() {
  var rng = Random();

  return rng.nextInt(100);
}
