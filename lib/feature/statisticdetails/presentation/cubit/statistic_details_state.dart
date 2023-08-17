part of 'statistic_details_cubit.dart';

abstract class StatisticDetailsState extends Equatable {

  @override
  List<Object> get props => [];

  const StatisticDetailsState();
}

class StatisticDetailsInitial extends StatisticDetailsState {
}


class StatisticDetailsInitialState extends StatisticDetailsState {

}

class StatisticsDetailsInitial extends StatisticDetailsState{}

class StatisticsDetailsIsLoading extends StatisticDetailsState{}

class StatisticsDetailsLoaded extends StatisticDetailsState{

  final StatisticDetails statisticDetails;

  const StatisticsDetailsLoaded({required this.statisticDetails});

  @override
  List<Object> get props =>[statisticDetails];
}

class StatisticsDetailsError extends StatisticDetailsState{
  final String msg;
  const StatisticsDetailsError({required this.msg});

  @override
  List<Object> get props =>[msg];
}