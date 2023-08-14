import 'package:claimizer/feature/login/data/models/login_model.dart';

abstract class LoginRemoteDataSource {

  Future<LoginModel> login(String email , String password);

  Future<void> saveUserInfo(LoginModel model);

}
