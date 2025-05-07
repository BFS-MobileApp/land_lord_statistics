import 'package:LandlordStatistics/feature/statistics/data/models/statistic_model.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Statistic extends Equatable{

  final List<StatisticSummary> statisticData;
  const Statistic({required this.statisticData});
  @override
  List<Object?> get props => [statisticData];

}