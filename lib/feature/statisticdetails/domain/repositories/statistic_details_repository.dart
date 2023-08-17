import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/feature/statisticdetails/domain/entities/statistic_details.dart';
import 'package:dartz/dartz.dart';

abstract class StatisticDetailsRepository {

  Future<Either<Failures , StatisticDetails>> getStatisticDetails(String uniqueId);
}
