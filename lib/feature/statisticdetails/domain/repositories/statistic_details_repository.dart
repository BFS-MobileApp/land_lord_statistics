import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/entities/statistic_details.dart';
import 'package:dartz/dartz.dart';

abstract class StatisticDetailsRepository {

  Future<Either<Failures , StatisticDetails>> getStatisticDetails(String uniqueId);
  Future<Either<Failures , NoParams>> setUserCompanySettings(String color , String uniqueId, double sort);
  Future<Either<Failures , NoParams>> setUserColumnsSettings(List<String> columnsSort);
}
