//import '<FILE_NAME>.config.dart';
import 'package:footy/features/PlayQuiz/Business/repository/selectedQuizrepo.dart';
import 'package:footy/features/PlayQuiz/Business/usecase/start_quiz.dart';
import 'package:footy/features/PlayQuiz/Data/repository/selectedQuizrepoImpl.dart';
import 'package:footy/features/PlayQuiz/Presentation/bloc/play_bloc.dart';
import 'package:footy/features/Quizzes/Data/DataSources/quizzes_local_data_source.dart';

import 'package:footy/features/Quizzes/Data/DataSources/quizzes_remote_data_source.dart';
import 'package:footy/features/Quizzes/Data/Repositories/quizzes_repository_impl.dart';
import 'package:footy/features/Quizzes/Presentation/bloc/quizzes_bloc.dart';

import 'package:footy/features/Quizzes/Business/UseCases/get_quizzes.dart';
import 'package:footy/features/Quizzes/Business/Repositories/quizzes_repository.dart';
import 'package:footy/features/multiplayer/business/repository/lobby_repository.dart';
import 'package:footy/features/multiplayer/business/usecase/get_lobby_users.dart';
import 'package:footy/features/multiplayer/data/backend/get_users.dart';
import 'package:footy/features/multiplayer/data/repository/lobby_repo_impl.dart';
import 'package:footy/features/multiplayer/bloc/multiplayer_lobby_bloc/multiplayer_bloc.dart';
import 'package:footy/core/Util/score.dart';
import 'package:footy/features/multiplayer/bloc/join_lobby_bloc/join_lobby_bloc.dart';
import 'package:footy/features/multiplayer/business/repository/quizzes_repo.dart';
import 'package:footy/features/multiplayer/business/usecase/get_quizzes.dart';
import 'package:footy/features/multiplayer/data/backend/get_quizzes.dart';
import 'package:footy/features/multiplayer/data/repository/quizzes_repo_impl.dart';
import 'package:footy/features/play_online/business/repositories/add_score_repo.dart';
import 'package:footy/features/play_online/business/repositories/delete_game_repo.dart';
import 'package:footy/features/play_online/business/repositories/get_quiz_online_repo.dart';
import 'package:footy/features/play_online/business/repositories/get_score_repo.dart';
import 'package:footy/features/play_online/business/repositories/get_time_repo.dart';
import 'package:footy/features/play_online/business/usecases/add_user_score.dart';
import 'package:footy/features/play_online/business/usecases/delete_game.dart';
import 'package:footy/features/play_online/business/usecases/get_quiz_online.dart';
import 'package:footy/features/play_online/business/usecases/get_score.dart';
import 'package:footy/features/play_online/business/usecases/get_time.dart';
import 'package:footy/features/play_online/data/backend/game_data.dart';
import 'package:footy/features/play_online/data/repository/add_score_repo_impl.dart';
import 'package:footy/features/play_online/data/repository/delete_game_repo_impl.dart';
import 'package:footy/features/play_online/data/repository/get_quiz_online_repo_impl.dart';
import 'package:footy/features/play_online/data/repository/get_score_repo_impl.dart';
import 'package:footy/features/play_online/data/repository/get_time_repo_impl.dart';

import 'package:footy/features/play_online/presentation/bloc/game_bloc.dart';
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

void initThree() {
  getIt.registerSingleton(GetUsers(client: getIt()));
  getIt.registerSingleton(GetRemoteQuizzesMultiplaer(client: getIt()));

  //repo
  getIt.registerSingleton<WaitingLobbyRepo>(
      WaitingLobbyRepoImpl(dataSource: getIt()));
  getIt.registerSingleton<QuizzesMultiplayerRepository>(
      QuizzesMultiplayerRepositoryImpl(remote: getIt()));

  //blocs
  getIt.registerFactory(() => JoinLobbyBloc(getIt()));

  getIt.registerFactory(() => MultiplayerBloc(getIt(), getIt()));

  //Usecase
  getIt.registerSingleton(GetPlayers(repo: getIt()));
  getIt.registerSingleton(GetQuizzesForMultiplayer(repository: getIt()));
}

void initFour() {
  getIt.registerSingleton(FetchGameData(client: getIt()));
  //repo
  getIt.registerSingleton<OnlinePlayQuizRepo>(
      OnlinePlayQuizRepoImpl(data: getIt()));
  getIt.registerSingleton<AddScoreRepo>(AddScoreRepoImpl(data: getIt()));
  getIt.registerSingleton<GetScoreRepo>(GetScoreRepoImpl(data: getIt()));
  getIt
      .registerSingleton<DeleteGameRepo>(DeleteGameRepoImpl(gameData: getIt()));
  getIt.registerSingleton<GetTimeRepo>(GetTimeRepoImpl(data: getIt()));

  //blocs
  getIt.registerFactory(
      () => GameBloc(getIt(), getIt(), getIt(), getIt(), getIt()));

  //Usecase
  getIt.registerSingleton(OnlinePlayQuiz(repository: getIt()));
  getIt.registerSingleton(GetScore(repository: getIt()));
  getIt.registerSingleton(AddScore(repo: getIt()));
  getIt.registerSingleton(DeleteGame(repo: getIt()));
  getIt.registerSingleton(GetTime(repository: getIt()));
}
