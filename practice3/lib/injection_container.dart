//import '<FILE_NAME>.config.dart';
import 'package:footy/Features/PlayQuiz/Business/repository/selectedQuizrepo.dart';
import 'package:footy/Features/PlayQuiz/Business/usecase/start_quiz.dart';
import 'package:footy/Features/PlayQuiz/Data/repository/selectedQuizrepoImpl.dart';
import 'package:footy/Features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:footy/Features/Quizzes/Data/DataSources/quizzes_local_data_source.dart';

import 'package:footy/Features/Quizzes/Data/DataSources/quizzes_remote_data_source.dart';
import 'package:footy/Features/Quizzes/Data/Repositories/quizzes_repository_impl.dart';
import 'package:footy/Features/Quizzes/Presentation/bloc/quizzes_bloc.dart';

import 'package:footy/Features/Quizzes/Business/UseCases/get_quizzes.dart';
import 'package:footy/Features/Quizzes/Business/Repositories/quizzes_repository.dart';
import 'package:footy/core/Util/score.dart';
import 'package:http/http.dart' as http;
import 'package:footy/core/network/network_info.dart';

import 'package:get_it/get_it.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

// @InjectableInit(
//   initializerName: 'init', // default
//   preferRelativeImports: true, // default
//   asExtension: true, // default
// )
// void configureDependencies() => getIt.init();

Future<void> init() async {
  //! Features
  final sharedpreference = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedpreference);
  getIt.registerSingleton(http.Client());
  getIt.registerSingleton(InternetConnectionChecker());

  getIt.registerSingleton<NetworkInfo>(
      NetworkInfoImpl(connectionChecker: getIt()));
//data source
  getIt.registerSingleton<QuizzesRemoteDataSource>(
      QuizzesRemoteDataSourceImpl(client: getIt()));
  getIt.registerSingleton<QuizzesLocalDataSource>(
      QuizzesLocalDataSourceImpl(sharedPreferences: getIt()));

  //repo
  getIt.registerSingleton<QuizzesRepository>(QuizzesRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt()));
//bloc
  getIt.registerFactory(() => QuizzesBloc(getIt()));

  //usecase
  getIt.registerSingleton(GetQuizzes(repository: getIt()));
}

Future<void> initTwo() async {
  //repository
  getIt.registerSingleton<SelectedQuizRepo>(
      SelectedQuizRepoImpl(localDataSource: getIt())); //

  //util
  getIt.registerSingleton(Score());

  //blocs
  getIt.registerFactory(() => PlayBloc(getIt(), getIt()));

  //Usecase
  getIt.registerSingleton(startQuiz(repo: getIt()));
}
