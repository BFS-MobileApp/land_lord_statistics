import 'package:LandlordStatistics/feature/statisticdetails/data/models/statistic_details_model.dart';

import '../models/units_model.dart';

abstract class StatisticDetailsRemoteDataSource {

  Future<StatisticDetailsModel> getStatisticDetails(String uniqueId,String claimStatus,int page);
  Future<UnitsModel> getUnits(String uniqueId);

  Future<void> setUserSettings(String color , String uniqueId , double sort);

  Future<void> setUserColumnSettings(List<String> columnSortList);
  Future<Map<String, dynamic>> getUserSettings();
}
