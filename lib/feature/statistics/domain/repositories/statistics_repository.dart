import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/feature/statistics/domain/entites/statistic.dart';
import 'package:dartz/dartz.dart';

abstract class StatisticsRepository {

  Future<Either<Failures , Statistic>> getStatistic();
}
