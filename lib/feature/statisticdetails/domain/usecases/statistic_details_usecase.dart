import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/feature/statisticdetails/domain/entities/statistic_details.dart';
import 'package:claimizer/feature/statisticdetails/domain/repositories/statistic_details_repository.dart';
import 'package:dartz/dartz.dart';

class StatisticDetailsUseCase implements UseCase<StatisticDetails , StatisticDetailsParams>{

  final StatisticDetailsRepository statisticDetailsRepository;

  StatisticDetailsUseCase({required this.statisticDetailsRepository});


  @override
  Future<Either<Failures, StatisticDetails>> call(StatisticDetailsParams params) => statisticDetailsRepository.getStatisticDetails(params.uniqueId);

}