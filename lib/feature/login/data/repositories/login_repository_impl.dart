import 'package:claimizer/config/PrefHelper/dbhelper.dart';
import 'package:claimizer/core/error/exceptions.dart';
import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/network/network_info.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:claimizer/feature/login/domain/entities/login.dart';
import 'package:claimizer/feature/login/domain/repositories/login_repository.dart';
import 'package:claimizer/feature/setting/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          saveUserInfo(email , response.name , response.token);
          return Right(response);
        } else {
          return Left(ServerFailure(msg: Helper.getCurrentLocal() == 'AR' ? 'invalidCredentials'.tr : response.message));
        }
      } on ServerException{
        return Left(ServerFailure(msg: 'error'.tr));
      }
    } else {
      return Left(CashFailure(msg: 'connectionError'.tr));
    }
  }

  @override
  Future<void> saveUserInfo(String email , String name , String token) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final databaseHelper = DatabaseHelper.instance;
    final user = UserModel(
      name: name,
      email: email,
      token: token,
      active: true,
    );
    databaseHelper.insertUser(user);
    databaseHelper.activateUser(email);
    preferences.setString(AppStrings.token, token);
    preferences.setString(AppStrings.userName, name);
  }
}
