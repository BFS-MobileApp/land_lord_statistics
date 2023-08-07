import 'package:claimizer/feature/statistics/data/models/statistic_model.dart';

abstract class StatisticsRemoteDataSource {

  Future<StatisticModel> getStatisticData();
}
