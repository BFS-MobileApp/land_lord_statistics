import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statistics/domain/repositories/statistics_repository.dart';
import 'package:dartz/dartz.dart';

class UserSettingsUseCase  implements UseCase<NoParams , StatisticCompanySettings>{

  final StatisticsRepository statisticsRepository;
  UserSettingsUseCase({required this.statisticsRepository});

  @override
  Future<Either<Failures, NoParams>> call(StatisticCompanySettings statisticCompanySettings) => statisticsRepository.setUserCompanySettings(statisticCompanySettings.color, statisticCompanySettings.sort, statisticCompanySettings.uniqueId);
}