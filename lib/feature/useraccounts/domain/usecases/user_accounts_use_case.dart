import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/feature/useraccounts/domain/entities/user.dart';
import 'package:claimizer/feature/useraccounts/domain/repositories/useraccounts_repository.dart';
import 'package:dartz/dartz.dart';

class UserAccountsUseCase implements UseCase<List<User> , NoParams>{

  final UserAccountsRepository userAccountsRepository;
  UserAccountsUseCase({required this.userAccountsRepository});
  @override
  Future<Either<Failures, List<User>>> call(NoParams params) => userAccountsRepository.getUserAccounts();

}