import 'package:claimizer/core/api/app_interceptor.dart';
import 'package:claimizer/core/api/dio_consumer.dart';
import 'package:claimizer/core/network/network_info.dart';
import 'package:claimizer/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:claimizer/feature/login/data/datasources/login_remote_data_source_impl.dart';
import 'package:claimizer/feature/login/data/repositories/login_repository_impl.dart';
import 'package:claimizer/feature/login/domain/repositories/login_repository.dart';
import 'package:claimizer/feature/login/domain/usecases/login_usecase.dart';
import 'package:claimizer/feature/login/presentation/cubit/login_cubit.dart';
import 'package:claimizer/feature/statisticdetails/data/datasources/statistic_details_remote_data_source.dart';
import 'package:claimizer/feature/statisticdetails/data/datasources/statistic_details_remote_data_source_impl.dart';
import 'package:claimizer/feature/statisticdetails/domain/usecases/statistic_details_usecase.dart';
import 'package:claimizer/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:claimizer/feature/statistics/data/datasources/statistics_remote_data_source.dart';
import 'package:claimizer/feature/statistics/data/datasources/statistics_remote_data_source_impl.dart';
import 'package:claimizer/feature/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:claimizer/feature/statistics/domain/repositories/statistics_repository.dart';
import 'package:claimizer/feature/statistics/domain/usecases/statistic_use_case.dart';
import 'package:claimizer/feature/statistics/domain/usecases/user_settings_use_case.dart';
import 'package:claimizer/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_consumer.dart';
import 'feature/statisticdetails/data/repositories/statistic_details_repository_impl.dart';
import 'feature/statisticdetails/domain/repositories/statistic_details_repository.dart';

final sl = GetIt.instance;

Future<void> init() async{

  //Blocs
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => StatisticCubit( statisticCompanySettings: sl() , statisticUseCase: sl()));
  sl.registerFactory(() => StatisticDetailsCubit(statisticDetailsUseCase: sl()));

  //UseCase
  sl.registerLazySingleton(() => LoginUseCase(loginRepository: sl()));
  sl.registerLazySingleton(() => StatisticUseCase(statisticsRepository: sl()));
  sl.registerLazySingleton(() => StatisticDetailsUseCase(statisticDetailsRepository: sl()));
  sl.registerLazySingleton(() => UserSettingsUseCase(statisticsRepository: sl()));

  //Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(loginRemoteDataSource: sl() , networkInfo: sl()));
  sl.registerLazySingleton<StatisticsRepository>(() => StatisticsRepositoryImpl(statisticsRemoteDataSource: sl() , networkInfo: sl()));
  sl.registerLazySingleton<StatisticDetailsRepository>(() => StatisticDetailsRepositoryImpl(statisticDetailsRemoteDataSource: sl() , networkInfo: sl()));

  //DataSource
  sl.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(consumer: sl()));
  sl.registerLazySingleton<StatisticsRemoteDataSource>(() => StatisticsRemoteDataSourceImpl(consumer: sl()));
  sl.registerLazySingleton<StatisticDetailsRemoteDataSource>(() => StatisticDetailsRemoteDataSourceImpl(consumer: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));


  //External
  final sharedPreference = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreference);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => AppInterceptor());
  sl.registerLazySingleton(() => Dio());
}