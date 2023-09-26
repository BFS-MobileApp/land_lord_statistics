import 'package:claimizer/config/PrefHelper/dbhelper.dart';
import 'package:claimizer/core/api/api_consumer.dart';
import 'package:claimizer/core/api/end_points.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:claimizer/feature/login/data/models/login_model.dart';
import 'package:claimizer/feature/setting/data/models/user_model.dart';
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
    saveUserInfo(LoginModel.fromJson(res) , email);
    return LoginModel.fromJson(res);
  }

  @override
  Future<void> saveUserInfo(LoginModel model , String email) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final databaseHelper = DatabaseHelper.instance;
    final user = UserModel(
      name: model.name,
      email: email,
      token: model.token,
      active: true,
    );
    databaseHelper.insertUser(user);
    databaseHelper.activateUser(email);
    preferences.setString(AppStrings.token, model.data.token);
    preferences.setString(AppStrings.userName, model.data.name);
  }

}
