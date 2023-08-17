import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';

abstract class StatisticDetailsRemoteDataSource {

  Future<StatisticDetailsModel> getStatisticDetails(String uniqueId);
}
