import 'package:equatable/equatable.dart';

class Quizzes extends Equatable {
  final String status;
  final int results;
  final Data data;

  const Quizzes({
    required this.status,
    required this.results,
    required this.data,
  });

  @override
  List<Object?> get props => [status, results, data];
}

class Data {
  List<Quize> quizes;

  Data({
    required this.quizes,
  });
}

class Quize {
  String id;
  String title;
  String image;
  List<Question> questions;

  String category;
  bool? featured;

  Quize({
    required this.id,
    required this.title,
    required this.image,
    required this.questions,
    required this.category,
    this.featured,
  });

  toJson() {}
}

class Question {
  String prompt;
  List<String> options;
  String answers;

  Question({
    required this.prompt,
    required this.options,
    required this.answers,
  });
}
