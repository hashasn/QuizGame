import 'package:footy/features/PlayQuiz/Business/Entities/quiz.dart';

// ignore: must_be_immutable
// class QuizModel extends Quiz {
//   QuizModel({
//     required super.id,
//     required super.title,
//     required super.image,
//     required super.questions,
//     required super.category,
//     super.featured,
//   });

//   factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
//         id: json["_id"] ?? '',
//         title: json["title"] ?? '',
//         image: json["image"] ?? '',
//         questions: (json["questions"] as List<dynamic>?)
//                 ?.map((q) => QuestionModel.fromJson(q))
//                 .toList() ??
//             [],
//         category: json["category"] ?? '',
//         featured: json["Featured"] ?? false,
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//         "image": image,
//         "questions": List<dynamic>.from(questions.map((x) => x)),
//         "category": category,
//         "Featured": featured,
//       };
// }

// class QuestionModel extends Question {
//   QuestionModel(
//       {required super.prompt, required super.options, required super.answers});

//   factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
//         prompt: json["prompt"],
//         options: List<String>.from(json["options"].map((x) => x)),
//         answers: json["answers"],
//       );

//   Map<String, dynamic> toJson() => {
//         "prompt": prompt,
//         "options": List<dynamic>.from(options.map((x) => x)),
//         "answers": answers,
//       };
// }
