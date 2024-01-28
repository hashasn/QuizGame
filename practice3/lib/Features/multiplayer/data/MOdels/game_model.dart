// class GameModel extends Equatable {
//   final String quizId;
//   final List<dynamic> users;

//   GameModel({required this.users, required this.quizId});

//   factory GameModel.fromJson(Map<String, dynamic> json) =>
//       GameModel(quizId: json['quiz'], users: json['users']);

//   Map<String, dynamic> toJson() => {'quiz': quizId, 'users': users};

//   @override
//   List<Object> get props => [users];

//   // static WaitingLobbyUser copy(WaitingLobbyUser original) {
//   //   return WaitingLobbyUser(
//   //       users: List.from(original.users), lobbyCode: original.lobbyCode);
//   // }
// }

class GameModel {
  String quiz;
  String gameCode;
  List<User> users;

  GameModel({
    required this.gameCode,
    required this.quiz,
    required this.users,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        gameCode: json['gameCode'],
        quiz: json["quiz"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "gameCode": gameCode,
        "quiz": quiz,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  String name;
  String score;

  User({
    required this.name,
    required this.score,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "score": score,
      };
}
