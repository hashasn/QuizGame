import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footy/Features/PlayQuiz/Presentation/Pages/QuizStartPage.dart';
import 'package:footy/Features/PlayQuiz/Presentation/widgets/loadingWidget.dart';
import 'package:footy/Features/Quizzes/Presentation/bloc/quizzes_bloc.dart';
import 'package:footy/Features/Quizzes/Presentation/Widgets/QuizzesDisplay.dart';
import 'package:footy/injection_container.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home'),
      ),
      body: buildBody(context),
    );
  }
}

// class buildBody extends StatelessWidget {
//   const buildBody(BuildContext context, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) => getIt<QuizzesBloc>(),
//       child: BlocBuilder<QuizzesBloc, QuizzesState>(
//         builder: (context, state) {
//           if (state is QuizzesInitial) {
//             BlocProvider.of<QuizzesBloc>(context).add(QuizzesInitialEvent());
//             return const CircularProgressIndicator();
//           } else if (state is LoadingState) {
//             return LoadingWidget(s: 'Loading....');
//           } else if (state is SuccessState) {
//             return QuizzesDisplay(
//               qs: state.qs,
//             );
//           } else if (state is ErrorState) {
//             return Text(state.error);
//           } else {
//             return Center(
//                 child: Column(
//               children: [
//                 Text('Error Occured'),
//                 ElevatedButton(
//                     onPressed: () {
//                       BlocProvider.of<QuizzesBloc>(context)
//                           .add(QuizzesInitialEvent());
//                     },
//                     child: Text('retry'))
//               ],
//             ));
//           }
//         },
//       ),
//     );
//   }
// }

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
          if (state is PlayButtonClickedState) {
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
                Text('Error Occured'),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<QuizzesBloc>(context)
                          .add(QuizzesInitialEvent());
                    },
                    child: Text('retry'))
              ],
            ));
          }
        },
      ),
    );
  }
}
