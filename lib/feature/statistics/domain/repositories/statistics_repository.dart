import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statistics/domain/entites/statistic.dart';
import 'package:dartz/dartz.dart';

abstract class StatisticsRepository {

  Future<Either<Failures , Statistic>> getStatistic();

  Future<Either<Failures , NoParams>> setUserCompanySettings(String color , double sort , String uniqueId);

  Future<Either<Failures , NoParams>> setUserCompanySortSettings(List<String> companiesSort);
}
