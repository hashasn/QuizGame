import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:footy/Features/PlayQuiz/Presentation/Pages/QuizStartPage.dart';
import 'package:footy/Features/Quizzes/Presentation/bloc/quizzes_bloc.dart';
import 'package:footy/Features/Quizzes/Business/Entities/quizzes.dart';

class QuizzesTiles extends StatelessWidget {
  final List<Quize> quiz;
  final int count;

  const QuizzesTiles({super.key, required this.quiz, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.greenAccent,
        child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(color: Colors.greenAccent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(quiz[count].image),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  quiz[count].title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  quiz[count].category,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                // Text(productData.category),
                const SizedBox(height: 20),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<QuizzesBloc>(context).add(
                                  QuizzesButtonClickedEvent(
                                      selectedQuiz: quiz[count]));
                            },
                            style: ElevatedButton.styleFrom(
                              // foregroundColor: Colors.white, // background
                              // backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('PLAY')),
                        // IconButton(
                        //     onPressed: () {

                        //     },
                        //     icon: const Icon(Icons.shopping_bag_outlined)),
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
