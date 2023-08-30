import 'package:claimizer/core/api/api_consumer.dart';
import 'package:claimizer/core/api/end_points.dart';
import 'package:claimizer/feature/statisticdetails/data/datasources/statistic_details_remote_data_source.dart';
import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';

import '../../../../core/utils/app_strings.dart';

class StatisticDetailsRemoteDataSourceImpl extends StatisticDetailsRemoteDataSource {

  ApiConsumer consumer;
  StatisticDetailsRemoteDataSourceImpl({required this.consumer});

  @override
  Future<StatisticDetailsModel> getStatisticDetails(String uniqueId) async{
    final res = await consumer.get(EndPoints.statisticDetails+uniqueId);
    return StatisticDetailsModel.fromJson(res);
  }

  @override
  Future<void> setUserSettings(String color, String uniqueId) async{
    final body = {
      AppStrings.columnStatisticDetails:{
        uniqueId:{
          AppStrings.color: color,
        },
      }
    };
    await consumer.post(EndPoints.updateStatisticsColumn , body: body);
  }

}
