import 'package:dio/dio.dart';
import 'package:flutter_project_structure/config/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/api_consumer.dart';
import 'core/api/app_interceptor.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/network_info.dart';
import 'core/preferences/flutter_secure_storage.dart';
import 'core/services/launch_urls.dart';
import 'core/services/share_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Blocs
  //sl.registerFactory(() => SignUpCubit(signUpUseCase: sl() , socialLoginUseCase: sl()));

  //Repository
  //sl.registerLazySingleton<SignUpRepository>(() => SignUpRepositoryImpl(signUpRemoteDataSource: sl(), networkInfo: sl()));

  //Data Sources
  //sl.registerLazySingleton<SignUpRemoteDataSource>(() => SignUpRemoteDataSourceImpl(consumer: sl()));

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
}
