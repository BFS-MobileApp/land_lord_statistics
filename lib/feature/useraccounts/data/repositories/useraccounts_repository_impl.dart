import 'package:claimizer/core/error/exceptions.dart';
import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/feature/useraccounts/data/datasources/useraccounts_remote_data_source.dart';
import 'package:claimizer/feature/useraccounts/domain/repositories/useraccounts_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../domain/entities/user.dart';

class UserAccountsRepositoryImpl extends UserAccountsRepository {

	UserAccountsLocalDataSource userAccountsLocalDataSource;
	UserAccountsRepositoryImpl({required this.userAccountsLocalDataSource});

  @override
  Future<Either<Failures, List<User>>> getUserAccounts() async{
		try{
			final response = await userAccountsLocalDataSource.getUsersAccountsList();
			return Right(response);
		} on ServerException{
			return Left(ServerFailure(msg: 'error'.tr));
		}
  }
}
