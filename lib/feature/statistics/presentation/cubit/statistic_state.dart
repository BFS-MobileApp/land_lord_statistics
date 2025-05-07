part of 'statistic_cubit.dart';

abstract class StatisticState extends Equatable {
  const StatisticState();

  @override
  List<Object> get props => [];
}

class StatisticInitial extends StatisticState {}

class StatisticsInitial extends StatisticState{}

class StatisticsIsLoading extends StatisticState{}

class StatisticsLoaded extends StatisticState{

  final Statistic statistic;

  const StatisticsLoaded({required this.statistic});

  @override
  List<Object> get props =>[statistic];
}

class StatisticsError extends StatisticState{
  final String msg;
  const StatisticsError({required this.msg});

  @override
  List<Object> get props =>[msg];
}

// ignore: must_be_immutable
class StatisticsRefresh extends StatisticState{

  List<StatisticSummary> statisticList = [];
  StatisticsRefresh({required this.statisticList});

  @override
  List<Object> get props =>[statisticList];
}