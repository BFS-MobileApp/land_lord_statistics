import 'package:LandlordStatistics/feature/statisticdetails/data/models/statistic_details_model.dart';

abstract class StatisticDetailsRemoteDataSource {

  Future<StatisticDetailsModel> getStatisticDetails(String uniqueId);

  Future<void> setUserSettings(String color , String uniqueId , double sort);

  Future<void> setUserColumnSettings(List<String> columnSortList);
}
