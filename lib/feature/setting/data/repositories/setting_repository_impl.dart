import 'package:LandlordStatistics/core/error/exceptions.dart';
import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/feature/setting/data/datasources/setting_local_data_source.dart';
import 'package:LandlordStatistics/feature/setting/domain/repositories/setting_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../domain/entities/user.dart';

class SettingRepositoryImpl extends SettingRepository {

	SettingLocalDataSource userAccountsLocalDataSource;
	SettingRepositoryImpl({required this.userAccountsLocalDataSource});

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
