import 'package:LandlordStatistics/core/error/failures.dart';

import 'package:LandlordStatistics/core/usecase/use_case.dart';

import 'package:dartz/dartz.dart';

import '../../data/models/units_model.dart';
import '../entities/statistic_details.dart';
import '../repositories/statistic_details_repository.dart';

class GetUnitsUseCase {
  final StatisticDetailsRepository repository;

  GetUnitsUseCase({required this.repository});

  Future<Either<Failures, UnitsModel>> call(String uniqueId) {
    return repository.getUnits(uniqueId);
  }
}