import 'package:claimizer/core/api/api_consumer.dart';
import 'package:claimizer/core/api/end_points.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:claimizer/feature/login/data/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRemoteDataSourceImpl extends LoginRemoteDataSource {
  ApiConsumer consumer;

  LoginRemoteDataSourceImpl({required this.consumer});
  @override
  Future<LoginModel> login(String email , String password) async{
    final body = {
      "email":email,
      "password":password
    };
    final res = await consumer.post(EndPoints.login  , body: body);
    saveUserInfo(LoginModel.fromJson(res));
    return LoginModel.fromJson(res);
  }

  @override
  Future<void> saveUserInfo(LoginModel model) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(AppStrings.token, model.data.token);
    preferences.setString(AppStrings.userName, model.data.name);
  }

}
