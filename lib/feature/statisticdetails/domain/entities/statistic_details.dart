import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';

class StatisticDetails{

  final List<StatisticColoumn> statisticColoumn;
  final List<ChartDatum> chartData;

  StatisticDetails({required this.statisticColoumn , required this.chartData});


}