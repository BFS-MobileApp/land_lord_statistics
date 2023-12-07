import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/repositories/statistic_details_repository.dart';
import 'package:dartz/dartz.dart';

class UserColumnSettingsUseCase  implements UseCase<NoParams , StatisticColumnSettings>{

  final StatisticDetailsRepository statisticDetailsRepository;
  UserColumnSettingsUseCase({required this.statisticDetailsRepository});

  @override
  Future<Either<Failures, NoParams>> call(StatisticColumnSettings statisticColumnSettings) => statisticDetailsRepository.setUserCompanySettings(statisticColumnSettings.color, statisticColumnSettings.uniqueId , statisticColumnSettings.sort);
}