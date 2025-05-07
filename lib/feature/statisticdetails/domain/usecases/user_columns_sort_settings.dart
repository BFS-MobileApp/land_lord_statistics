import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/repositories/statistic_details_repository.dart';
import 'package:dartz/dartz.dart';

class UserColumnSortSettingsUseCase  implements UseCase<NoParams , StatisticColumnSortSettings>{

  final StatisticDetailsRepository statisticDetailsRepository;
  UserColumnSortSettingsUseCase({required this.statisticDetailsRepository});

  @override
  Future<Either<Failures, NoParams>> call(StatisticColumnSortSettings statisticColumnSortSettings) => statisticDetailsRepository.setUserColumnsSettings(statisticColumnSortSettings.columnsSorts);

}