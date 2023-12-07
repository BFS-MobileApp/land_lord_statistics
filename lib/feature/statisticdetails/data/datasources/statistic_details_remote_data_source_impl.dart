import 'package:LandlordStatistics/core/api/api_consumer.dart';
import 'package:LandlordStatistics/core/api/end_points.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/datasources/statistic_details_remote_data_source.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/models/statistic_details_model.dart';

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
  Future<void> setUserSettings(String color, String uniqueId, double sort) async{
    final body = {
      AppStrings.columnStatisticDetails:{
        uniqueId:{
          AppStrings.color:color == '' ? null : color,
          //AppStrings.sort:sort
        },
      }
    };
    await consumer.post(EndPoints.updateStatisticsColumn , body: body);
  }

  @override
  Future<void> setUserColumnSettings(List<String> columnSortList) async{
    final body = {
      AppStrings.columnsSort: columnSortList
    };
    await consumer.post(EndPoints.updateColumnsSort , body: body);
  }

}
