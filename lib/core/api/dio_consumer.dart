import 'dart:convert';
import 'dart:io';
import 'package:LandlordStatistics/core/api/api_consumer.dart';
import 'package:LandlordStatistics/core/api/app_interceptor.dart';
import 'package:LandlordStatistics/core/api/end_points.dart';
import 'package:LandlordStatistics/core/api/status_code.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:LandlordStatistics/injection_container.dart' as di;

import '../error/exceptions.dart';

class DioConsumer implements ApiConsumer{

  final Dio client;

  DioConsumer({required this.client}){
    (client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
    client.options
    ..baseUrl = EndPoints.betaUrl
    ..responseType = ResponseType.plain
    ..followRedirects = false
    ..connectTimeout =  const Duration(seconds: 15)
    ..receiveTimeout =  const Duration(seconds: 15)
    ..validateStatus = (status){
      return status! < StatusCode.internalServerError;
    };
    client.interceptors.add(di.sl<AppInterceptor>());
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParams}) async{
    try {
      final response = await client.get(path, queryParameters: queryParams);
      return handleResponseAsJson(response);
    } on DioException catch (error) {
      handleDioError(error);
    }
  }

  @override
  Future post(String path, {Map<String, dynamic>? queryParams, body , bool isFormData = false}) async{
    try {
      final response = await client.post(path, queryParameters: queryParams , data: isFormData ? FormData.fromMap(body!) : body);
      return handleResponseAsJson(response);
    } on DioException catch (error) {
      handleDioError(error);
    }
  }

  @override
  Future put(String path, {Map<String, dynamic>? queryParams, Map<String, dynamic>? body , bool isFormData = false}) async{
    try {
      final response = await client.put(path, queryParameters: queryParams , data: isFormData ? FormData.fromMap(body!) : body);
      return handleResponseAsJson(response);
    } on DioException catch (error) {
      handleDioError(error);
    }
  }


  dynamic handleResponseAsJson(Response<dynamic> response) {
      final responseJson = jsonDecode(response.data.toString());
      return responseJson;
  }

  dynamic handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.badCertificate:
        throw const BadCertificateException();
      case DioExceptionType.badResponse:
        throw const BadResponseException();
      case DioExceptionType.connectionError:
        throw const ConnectionErrorException();
      case DioExceptionType.unknown:
        throw const UnknownDioErrorException();
    }
    switch (error.response?.statusCode) {
      case StatusCode.badRequest:
        throw const BadRequestException();
      case StatusCode.unauthorized:
      case StatusCode.forBidden:
        throw const UnauthorizedException();
      case StatusCode.notFound:
        throw const NotFoundException();
      case StatusCode.conflict:
        throw const ConflictException();
      case StatusCode.internalServerError:
        throw const InternalServerErrorException();
      default:
        throw const BadResponseException(); // Add a default case for unhandled response codes
    }
  }
}