import 'package:claimizer/core/api/api_consumer.dart';
import 'package:claimizer/core/api/end_points.dart';
import 'package:claimizer/feature/statisticdetails/data/datasources/statistic_details_remote_data_source.dart';
import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';

class StatisticDetailsRemoteDataSourceImpl extends StatisticDetailsRemoteDataSource {

  ApiConsumer consumer;
  StatisticDetailsRemoteDataSourceImpl({required this.consumer});

  @override
  Future<StatisticDetailsModel> getStatisticDetails(String uniqueId) async{
    final res = await consumer.get(EndPoints.statisticDetails+uniqueId);
    return StatisticDetailsModel.fromJson(res);
  }

}
