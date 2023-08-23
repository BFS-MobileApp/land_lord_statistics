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

  final Data data;

  const StatisticsDetailsLoaded({required this.data});

  @override
  List<Object> get props =>[data];
}

class StatisticsDetailsError extends StatisticDetailsState{
  final String msg;
  const StatisticsDetailsError({required this.msg});

  @override
  List<Object> get props =>[msg];
}