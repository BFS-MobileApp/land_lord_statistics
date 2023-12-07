import 'package:LandlordStatistics/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/usecase/use_case.dart';
import '../repositories/statistics_repository.dart';

class UserCompaniesSortSetting implements UseCase<NoParams , StatisticCompanySortSettings>{

  final StatisticsRepository statisticsRepository;
  UserCompaniesSortSetting({required this.statisticsRepository});

  @override
  Future<Either<Failures, NoParams>> call(StatisticCompanySortSettings statisticCompanySortSettings) => statisticsRepository.setUserCompanySortSettings(statisticCompanySortSettings.companiesSort);

}