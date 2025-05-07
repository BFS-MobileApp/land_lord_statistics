import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/setting/domain/entities/user.dart';
import 'package:LandlordStatistics/feature/setting/domain/repositories/setting_repository.dart';
import 'package:dartz/dartz.dart';

class SettingUseCase implements UseCase<List<User> , NoParams>{

  final SettingRepository userAccountsRepository;
  SettingUseCase({required this.userAccountsRepository});
  @override
  Future<Either<Failures, List<User>>> call(NoParams params) => userAccountsRepository.getUserAccounts();

}