import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/entities/statistic_details.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/repositories/statistic_details_repository.dart';
import 'package:dartz/dartz.dart';

class StatisticDetailsUseCase implements UseCase<StatisticDetails , StatisticDetailsParams>{

  final StatisticDetailsRepository statisticDetailsRepository;

  StatisticDetailsUseCase({required this.statisticDetailsRepository});


  @override
  Future<Either<Failures, StatisticDetails>> call(StatisticDetailsParams params) => statisticDetailsRepository.getStatisticDetails(params.uniqueId);

}
class UserSettingsDetailsUseCase implements UseCase<Map<String, dynamic>, NoParams> {
  final StatisticDetailsRepository repository;

  UserSettingsDetailsUseCase({required this.repository});

  @override
  Future<Either<Failures, Map<String, dynamic>>> call(NoParams params) {
    return repository.getUserSettings();
  }
}