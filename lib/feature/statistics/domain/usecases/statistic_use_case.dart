import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statistics/domain/entites/statistic.dart';
import 'package:LandlordStatistics/feature/statistics/domain/repositories/statistics_repository.dart';
import 'package:dartz/dartz.dart';

class StatisticUseCase implements UseCase<Statistic , NoParams>{

  final StatisticsRepository statisticsRepository;
  StatisticUseCase({required this.statisticsRepository});
  @override
  Future<Either<Failures, Statistic>> call(NoParams params) => statisticsRepository.getStatistic();

}