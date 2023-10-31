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
    if(res.toString().contains('Unauthenticated')){
      Data data = Data(statisticSummary: [], count: 0);
      StatisticModel model = StatisticModel(status: 400, data: data);
      return model;
    }
    return StatisticModel.fromJson(res);
  }
  @override
  Future<void> setUserSettings(String color , double sort , String uniqueId)  async{

    final body = {
      AppStrings.companyStatisticDetails:{
        uniqueId:{
          AppStrings.color:color == '' ? null : color,
          //AppStrings.sort:sort.toString()
        },
      }
    };
    await consumer.post(EndPoints.updateStatisticsCompany , body: body);
  }

  @override
  Future<void> setUserSortSettings(List<String> companiesList) async{
    final body = {
      AppStrings.companiesSort: companiesList
    };
    await consumer.post(EndPoints.updateCompaniesSort , body: body);
  }



}
