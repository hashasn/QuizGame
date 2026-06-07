import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/features/PlayQuiz/Presentation/Pages/QuizStartPage.dart';
import 'package:footy/features/PlayQuiz/Presentation/widgets/loadingWidget.dart';
import 'package:footy/features/Quizzes/Presentation/bloc/quizzes_bloc.dart';
import 'package:footy/features/Quizzes/Presentation/Widgets/QuizzesDisplay.dart';
import 'package:footy/injection_container.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose a Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: buildBody(context),
    );
  }
}

class buildBody extends StatelessWidget {
  const buildBody(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<QuizzesBloc>(),
      child: BlocConsumer<QuizzesBloc, QuizzesState>(
        listenWhen: (previous, current) => current is QuizzesActionState,
        buildWhen: (previous, current) => current is! QuizzesActionState,
        listener: (context, state) {
          if (state is StartQuizzesState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizStartPage()),
            );
          }
        },
        builder: (context, state) {
          if (state is QuizzesInitial) {
            BlocProvider.of<QuizzesBloc>(context).add(QuizzesInitialEvent());
            return const CircularProgressIndicator();
          } else if (state is LoadingState) {
            return LoadingWidget(s: 'Loading....');
          } else if (state is SuccessState) {
            return QuizzesDisplay(
              qs: state.qs,
            );
          } else if (state is ErrorState) {
            return Text(state.error);
          } else {
            return Center(
                child: Column(
              children: [
                const Text('Error Occured'),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<QuizzesBloc>(context)
                          .add(QuizzesInitialEvent());
                    },
                    child: const Text('retry'))
              ],
            ));
          }
        },
      ),
    );
  }
}
