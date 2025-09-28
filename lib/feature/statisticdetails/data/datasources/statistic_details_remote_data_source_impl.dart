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
  Future<Map<String, dynamic>> getUserSettings() async {
    final res = await consumer.get(EndPoints.userSettings);
    return res['data'];
  }

  @override
  Future<void> setUserSettings(String color, String uniqueId, double sort) async {
    try {
      print("🟡 setUserSettings called with:");
      print("   color: $color");
      print("   uniqueId: $uniqueId");
      print("   sort: $sort");

      final body = {
        AppStrings.columnStatisticDetails: {
          uniqueId: {
            AppStrings.color: color == '' ? null : color,
            //AppStrings.sort: sort,
          },
        }
      };

      print("📦 Request body: $body");

      final response = await consumer.post(
        EndPoints.updateStatisticsColumn,
        body: body,
      );

      print("✅ API response: $response");
    } catch (e, stackTrace) {
      print("❌ Error in setUserSettings: $e");
      print(stackTrace);
      rethrow; // keep throwing if you want Cubit/Bloc to catch it
    }
  }


  @override
  Future<void> setUserColumnSettings(List<String> columnSortList) async {
    try {
      print("🟡 setUserColumnSettings called with:");
      print("   columnSortList: $columnSortList");

      final body = {
        AppStrings.columnsSort: columnSortList,
      };

      print("📦 Request body: $body");

      final response = await consumer.post(
        EndPoints.updateColumnsSort,
        body: body,
      );

      print("✅ API response: $response");
    } catch (e, stackTrace) {
      print("❌ Error in setUserColumnSettings: $e");
      print(stackTrace);
      rethrow;
    }
  }


}
