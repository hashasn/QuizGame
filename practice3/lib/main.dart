import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:footy/Features/multiplayer/Presentation/pages/menu_page.dart';
import 'package:footy/features/PlayQuiz/Presentation/Pages/quiz_result_page.dart';
import 'package:footy/features/play_online/presentation/pages/results_page.dart';
import 'package:footy/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //configureDependencies();
  await di.init();
  await di.initTwo();
  di.initThree();
  di.initFour();
  // di.initFour();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            useMaterial3: true,
            primaryColor: Colors.green[800],
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            )),
        home: MenuPage());
  }
}
