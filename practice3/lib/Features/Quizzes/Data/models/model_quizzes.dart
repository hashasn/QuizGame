import 'package:footy/features/Quizzes/Business/Entities/quizzes.dart';

class QuizzesModel extends Quizzes {
  const QuizzesModel(
      {required super.status, required super.results, required super.data});
  factory QuizzesModel.fromJson(Map<String, dynamic> json) => QuizzesModel(
        status: json["status"],
        results: json["results"],
        data: DataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "results": results,
        "data": data,
      };
}

class DataModel extends Data {
  DataModel({required super.quizes});
  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        quizes:
            List<Quize>.from(json["quizes"].map((x) => QuizeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "quizes": List<dynamic>.from(quizes.map((x) => x)),
      };
}

class QuizeModel extends Quize {
  QuizeModel({
    required super.id,
    required super.title,
    required super.image,
    required super.questions,
    required super.category,
    required super.featured,
  });
  factory QuizeModel.fromJson(Map<String, dynamic> json) => QuizeModel(
        id: json["_id"] ?? '',
        title: json["title"] ?? '',
        image: json["image"] ?? '',
        questions: (json["questions"] as List<dynamic>?)
                ?.map((q) => QuestionModel.fromJson(q))
                .toList() ??
            [],
        category: json["category"] ?? '',
        featured: json["Featured"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "image": image,
        "questions": List<dynamic>.from(questions.map((x) => x)),
        "category": category,
        "Featured": featured,
      };
}

class QuestionModel extends Question {
  QuestionModel({
    required super.prompt,
    required super.options,
    required super.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        prompt: json["prompt"],
        options: List<String>.from(json["options"].map((x) => x)),
        answers: json["answers"],
      );

  Map<String, dynamic> toJson() => {
        "prompt": prompt,
        "options": List<dynamic>.from(options.map((x) => x)),
        "answers": answers,
      };
}



// {
//     "status": "Success",
//     "results": 6,
//     "data": {
//         "quizes": [ ]
//     }
// }