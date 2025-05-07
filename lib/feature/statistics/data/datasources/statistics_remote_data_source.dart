import 'package:LandlordStatistics/feature/statistics/data/models/statistic_model.dart';

abstract class StatisticsRemoteDataSource {

  Future<StatisticModel> getStatisticData();

  Future<void> setUserSettings(String color , double sort , String uniqueId);

  Future<void> setUserSortSettings(List<String> companiesList);
}
