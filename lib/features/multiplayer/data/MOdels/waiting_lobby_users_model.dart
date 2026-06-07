import 'package:equatable/equatable.dart';

class WaitingLobbyUser extends Equatable {
  final String lobbyCode;
  final List<dynamic> users;

  WaitingLobbyUser({required this.users, required this.lobbyCode});

  factory WaitingLobbyUser.fromJson(Map<String, dynamic> json) =>
      WaitingLobbyUser(lobbyCode: json['lobbyCode'], users: json['users']);

  Map<String, dynamic> toJson() => {'lobbyCode': lobbyCode, 'users': users};

  @override
  List<Object> get props => [users];

  // static WaitingLobbyUser copy(WaitingLobbyUser original) {
  //   return WaitingLobbyUser(
  //       users: List.from(original.users), lobbyCode: original.lobbyCode);
  // }
}


// class Users {

//   final List<dynamic> users;

//   Users({required this.users});

//   Map<String,dynamic> toJson() => {'users': users};

// }
