import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';

bool compareAnswer(Question q, String options) {
  if (options == q.answers) return true;

  return false;
}
