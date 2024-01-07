import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:footy/Features/Quizzes/Presentation/pages/QuizzesPage.dart';
import 'package:footy/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //configureDependencies();
  await di.init();
  await di.initTwo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.green[800],
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: MyWidget(),
    );
  }
}
