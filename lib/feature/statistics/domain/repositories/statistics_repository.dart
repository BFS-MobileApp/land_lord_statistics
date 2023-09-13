import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/feature/statistics/domain/entites/statistic.dart';
import 'package:dartz/dartz.dart';

abstract class StatisticsRepository {

  Future<Either<Failures , Statistic>> getStatistic();

  Future<Either<Failures , NoParams>> setUserCompanySettings(String color , double sort , String uniqueId);
}
