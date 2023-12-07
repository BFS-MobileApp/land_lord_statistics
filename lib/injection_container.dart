import 'package:LandlordStatistics/core/api/app_interceptor.dart';
import 'package:LandlordStatistics/core/api/dio_consumer.dart';
import 'package:LandlordStatistics/core/network/network_info.dart';
import 'package:LandlordStatistics/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:LandlordStatistics/feature/login/data/datasources/login_remote_data_source_impl.dart';
import 'package:LandlordStatistics/feature/login/data/repositories/login_repository_impl.dart';
import 'package:LandlordStatistics/feature/login/domain/repositories/login_repository.dart';
import 'package:LandlordStatistics/feature/login/domain/usecases/login_usecase.dart';
import 'package:LandlordStatistics/feature/login/presentation/cubit/login_cubit.dart';
import 'package:LandlordStatistics/feature/setting/data/datasources/setting_local_data_source.dart';
import 'package:LandlordStatistics/feature/setting/data/repositories/setting_repository_impl.dart';
import 'package:LandlordStatistics/feature/setting/domain/repositories/setting_repository.dart';
import 'package:LandlordStatistics/feature/setting/domain/usecases/setting_use_case.dart';
import 'package:LandlordStatistics/feature/setting/presentation/cubit/setting_cubit.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/datasources/statistic_details_remote_data_source.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/datasources/statistic_details_remote_data_source_impl.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/usecases/statistic_details_usecase.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/usecases/user_column_settings_use_case.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/usecases/user_columns_sort_settings.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:LandlordStatistics/feature/statistics/data/datasources/statistics_remote_data_source.dart';
import 'package:LandlordStatistics/feature/statistics/data/datasources/statistics_remote_data_source_impl.dart';
import 'package:LandlordStatistics/feature/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:LandlordStatistics/feature/statistics/domain/repositories/statistics_repository.dart';
import 'package:LandlordStatistics/feature/statistics/domain/usecases/statistic_use_case.dart';
import 'package:LandlordStatistics/feature/statistics/domain/usecases/user_settings_use_case.dart';
import 'package:LandlordStatistics/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/PrefHelper/dbhelper.dart';
import 'core/api/api_consumer.dart';
import 'feature/setting/data/datasources/setting_local_data_source_impl.dart';
import 'feature/statisticdetails/data/repositories/statistic_details_repository_impl.dart';
import 'feature/statisticdetails/domain/repositories/statistic_details_repository.dart';
import 'feature/statistics/domain/usecases/user_comanies_sort_setting.dart';

final sl = GetIt.instance;

Future<void> init() async{

  //Blocs
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => StatisticCubit(statisticCompanySettings: sl() , userCompaniesSortSetting: sl() , statisticUseCase: sl()));
  sl.registerFactory(() => StatisticDetailsCubit(userColumnSortSettingsUseCase: sl(), userColumnSettingsUseCase: sl(), statisticDetailsUseCase: sl()));
  sl.registerFactory(() => SettingCubit(dbHelper: sl(),userAccountsUseCase: sl()));

  //UseCase
  sl.registerLazySingleton(() => LoginUseCase(loginRepository: sl()));
  sl.registerLazySingleton(() => StatisticUseCase(statisticsRepository: sl()));
  sl.registerLazySingleton(() => StatisticDetailsUseCase(statisticDetailsRepository: sl()));
  sl.registerLazySingleton(() => UserSettingsUseCase(statisticsRepository: sl()));
  sl.registerLazySingleton(() => UserColumnSettingsUseCase(statisticDetailsRepository: sl()));
  sl.registerLazySingleton(() => UserCompaniesSortSetting(statisticsRepository: sl()));
  sl.registerLazySingleton(() => UserColumnSortSettingsUseCase(statisticDetailsRepository: sl()));
  sl.registerLazySingleton(() => SettingUseCase(userAccountsRepository: sl()));

  //Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(loginRemoteDataSource: sl() , networkInfo: sl()));
  sl.registerLazySingleton<StatisticsRepository>(() => StatisticsRepositoryImpl(statisticsRemoteDataSource: sl() , networkInfo: sl()));
  sl.registerLazySingleton<StatisticDetailsRepository>(() => StatisticDetailsRepositoryImpl(statisticDetailsRemoteDataSource: sl() , networkInfo: sl()));
  sl.registerLazySingleton<SettingRepository>(() => SettingRepositoryImpl(userAccountsLocalDataSource: sl()));

  //DataSource
  sl.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(consumer: sl()));
  sl.registerLazySingleton<StatisticsRemoteDataSource>(() => StatisticsRemoteDataSourceImpl(consumer: sl()));
  sl.registerLazySingleton<StatisticDetailsRemoteDataSource>(() => StatisticDetailsRemoteDataSourceImpl(consumer: sl()));
  sl.registerLazySingleton<SettingLocalDataSource>(() => SettingLocalDataSourceImpl(dbhelper: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));


  //External
  final sharedPreference = await SharedPreferences.getInstance();
  final databaseHelper = DatabaseHelper.instance;
  sl.registerLazySingleton(() => sharedPreference);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => AppInterceptor());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => databaseHelper);
}