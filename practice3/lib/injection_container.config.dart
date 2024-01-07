// // GENERATED CODE - DO NOT MODIFY BY HAND

// // **************************************************************************
// // InjectableConfigGenerator
// // **************************************************************************

// // ignore_for_file: type=lint
// // coverage:ignore-file

// // ignore_for_file: no_leading_underscores_for_library_prefixes
// import 'package:footy/features/Quizzes/Data/DataSources/quizzes_local_data_source.dart';
// import 'package:footy/features/Quizzes/Data/DataSources/quizzes_remote_data_source.dart';
// import 'package:get_it/get_it.dart' as _i1;
// import 'package:http/http.dart' as _i11;
// import 'package:injectable/injectable.dart' as _i2;
// import 'package:internet_connection_checker/internet_connection_checker.dart'
//     as _i6;
// import 'package:shared_preferences/shared_preferences.dart' as _i9;

// import 'core/network/network_info.dart' as _i5;
// import 'Features/Quizzes/Business/Repositories/quizzes_repository.dart' as _i4;
// import 'Features/Quizzes/Business/UseCases/get_quizzes.dart' as _i3;
// import 'Features/Quizzes/Data/DataSources/quizzes_local_data_source.dart'
//     as _i8;
// import 'Features/Quizzes/Data/DataSources/quizzes_remote_data_source.dart'
//     as _i10;
// import 'Features/Quizzes/Data/Repositories/quizzes_repository_impl.dart'
//     as _i12;
// import 'Features/Quizzes/Presentation/bloc/quizzes_bloc.dart' as _i7;

// extension GetItInjectableX on _i1.GetIt {
// // initializes the registration of main-scope dependencies inside of GetIt
//   Future<_i1.GetIt> init({
//     String? environment,
//     _i2.EnvironmentFilter? environmentFilter,
//   }) async {
//     final gh = _i2.GetItHelper(
//       this,
//       environment,
//       environmentFilter,
//     );
//     final sharedpreference = await _i9.SharedPreferences.getInstance();
//     gh.singleton<_i9.SharedPreferences>(sharedpreference);
//     gh.singleton<_i6.InternetConnectionChecker>(
//         _i6.InternetConnectionChecker());
//     gh.singleton<_i11.Client>(_i11.Client());

//     gh.singleton<_i5.NetworkInfo>(_i5.NetworkInfoImpl(
//         connectionChecker: gh<_i6.InternetConnectionChecker>()));

//     gh.singleton<_i8.QuizzesLocalDataSource>(_i8.QuizzesLocalDataSourceImpl(
//         sharedPreferences: gh<_i9.SharedPreferences>()));
//     gh.singleton<_i10.QuizzesRemoteDataSource>(
//         _i10.QuizzesRemoteDataSourceImpl(client: gh<_i11.Client>()));
//     gh.singleton<_i4.QuizzesRepository>(_i12.QuizzesRepositoryImpl(
//       remoteDataSource: gh<QuizzesRemoteDataSource>(),
//       localDataSource: gh<QuizzesLocalDataSource>(),
//       networkInfo: gh<_i5.NetworkInfo>(),
//     ));
//     gh.singleton<_i3.GetQuizzes>(
//         _i3.GetQuizzes(repository: gh<_i4.QuizzesRepository>()));
//     gh.factory(() => _i7.QuizzesBloc(gh<_i3.GetQuizzes>()));
//     return this;
//   }
// }
