import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AppInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    options.headers = getHeaders();
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

  Map<String , dynamic> getHeaders(){
    Map<String , dynamic> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      //"Accept": "application/json",
    };
    return header;
  }

}