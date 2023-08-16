import 'package:claimizer/core/error/exceptions.dart';
import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/network/network_info.dart';
import 'package:claimizer/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:claimizer/feature/login/domain/entities/login.dart';
import 'package:claimizer/feature/login/domain/repositories/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

class LoginRepositoryImpl extends LoginRepository {

	final NetworkInfo networkInfo;
  final LoginRemoteDataSource loginRemoteDataSource;

	LoginRepositoryImpl({required this.networkInfo ,required this.loginRemoteDataSource});

  @override
  Future<Either<Failures, Login>> login(String email, String password) async{
    if(await networkInfo.isConnected){
      try{
        final response = await loginRemoteDataSource.login(email, password);
        if(response.data.token != ''){
          return Right(response);
        } else {
          return Left(ServerFailure(msg: response.message));
        }
      } on ServerException{
        return Left(ServerFailure(msg: 'error'.tr));
      }
    } else {
      return Left(CashFailure(msg: 'connectionError'.tr));
    }
  }
}
