import 'package:shared_preferences/shared_preferences.dart';

Future<String?> passQuize() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();

  return pref.getString('Cached_Quizz');
}
