import 'package:LandlordStatistics/core/api/api_consumer.dart';
import 'package:LandlordStatistics/core/api/end_points.dart';
import 'package:LandlordStatistics/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:LandlordStatistics/feature/login/data/models/login_model.dart';

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
    return LoginModel.fromJson(res);
  }
}
