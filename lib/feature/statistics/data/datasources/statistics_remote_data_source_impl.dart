import 'package:claimizer/core/api/api_consumer.dart';
import 'package:claimizer/core/api/end_points.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/feature/statistics/data/datasources/statistics_remote_data_source.dart';
import 'package:claimizer/feature/statistics/data/models/statistic_model.dart';

class StatisticsRemoteDataSourceImpl extends StatisticsRemoteDataSource {

  ApiConsumer consumer;

  StatisticsRemoteDataSourceImpl({required this.consumer});

  @override
  Future<StatisticModel> getStatisticData() async{
    final res = await consumer.get(EndPoints.statistic);
    return StatisticModel.fromJson(res);
  }

  @override
  Future<void> setUserSettings(String color , int sort , String uniqueId)  async{
    final body = {
      AppStrings.companyStatisticDetails:{
        uniqueId:{
          AppStrings.color:color,
          AppStrings.sort:sort.toString()
        },
      }
    };
    await consumer.post(EndPoints.updateStatisticsCompany , body: body);
  }

}
