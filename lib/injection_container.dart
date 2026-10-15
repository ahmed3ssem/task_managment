import 'package:dio/dio.dart';
import 'package:flutter_project_structure/config/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_database/firebase_database.dart';

import 'core/api/api_consumer.dart';
import 'core/api/app_interceptor.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/network_info.dart';
import 'core/preferences/flutter_secure_storage.dart';
import 'core/services/launch_urls.dart';
import 'core/services/share_service.dart';
import 'feature/tasks/data/datasources/tasks_remote_data_source.dart';
import 'feature/tasks/data/repositories/tasks_repository_impl.dart';
import 'feature/tasks/domain/repositories/tasks_repository.dart';
import 'feature/tasks/domain/usecases/create_board_usecase.dart';
import 'feature/tasks/domain/usecases/get_boards_usecase.dart';
import 'feature/tasks/presentation/cubit/tasks_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Tasks
  // Blocs
  sl.registerFactory<TasksCubit>(
    () => TasksCubit(createBoardUseCase: sl(), getBoardsUseCase: sl()),
  );

  // UseCases
  sl.registerLazySingleton<CreateBoardUseCase>(
    () => CreateBoardUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetBoardsUseCase>(
    () => GetBoardsUseCase(repository: sl()),
  );

  // Repository
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSourceImpl(database: sl()),
  );

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  //Services
  sl.registerLazySingleton<MySecureStorage>(() => MySecureStorage());
  sl.registerLazySingleton<LaunchUrlsService>(() => LaunchUrlsService());
  sl.registerLazySingleton<ShareService>(() => ShareService());

  //External
  final sharedPreference = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreference);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => AppInterceptor());
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);
}
