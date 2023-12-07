import 'package:LandlordStatistics/config/PrefHelper/dbhelper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AppInterceptor extends Interceptor{


  @override
   Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    Map<String , dynamic> headers = {};
    headers = await getHeaders();
    options.headers = headers;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }

  Future<Map<String , dynamic>> getHeaders() async{
    String token = '';
    token = await returnUserToken();
    Map<String , dynamic> header = {
      "Accept":"application/json",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    return header;
  }

  Future<String> returnUserToken() async{
    String token = '';
    final databaseHelper = DatabaseHelper.instance;
    await databaseHelper.getActiveUserToken().then((value) => token = value);
    return token;
  }
}