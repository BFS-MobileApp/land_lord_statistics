import 'dart:convert';

import 'package:LandlordStatistics/core/error/exceptions.dart';
import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/network/network_info.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statistics/data/datasources/statistics_remote_data_source.dart';
import 'package:LandlordStatistics/feature/statistics/domain/entites/statistic.dart';
import 'package:LandlordStatistics/feature/statistics/domain/repositories/statistics_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class StatisticsRepositoryImpl extends StatisticsRepository {

	final NetworkInfo networkInfo;
	final StatisticsRemoteDataSource statisticsRemoteDataSource;
	StatisticsRepositoryImpl({required this.networkInfo , required this.statisticsRemoteDataSource});

  @override
	Future<Either<Failures, Statistic>> getStatistic() async {
		if (await networkInfo.isConnected) {
			try {
				final response = await statisticsRemoteDataSource.getStatisticData();

				return Right(response);

			} on DioError catch (e) {
				String errorMessage = 'error'.tr;
				try {
					if (e.response?.data != null) {
						if (e.response!.data is Map<String, dynamic>) {
							errorMessage = e.response!.data['error'] ?? 'error'.tr;
						}
						else if (e.response!.data is String) {
							final body = jsonDecode(e.response!.data);
							errorMessage = body['error'] ?? 'error'.tr;
						}
					}
				} catch (_) {
					errorMessage = 'error'.tr;
				}

				return Left(ServerFailure(msg: errorMessage));
			} catch (e) {
				return Left(ServerFailure(msg: e.toString()));
			}
		} else {
			return Left(CashFailure(msg: 'no_connection'.tr));
		}
	}


	@override
  Future<Either<Failures, NoParams>> setUserCompanySettings(String color , double sort , String uniqueId) async{
		if(await networkInfo.isConnected){
			try{
				await statisticsRemoteDataSource.setUserSettings(color, sort, uniqueId);
				return Right(NoParams());
			} on ServerException{
				return Left(ServerFailure(msg: 'error'.tr));
			}
		} else {
			return Left(CashFailure(msg: 'error'.tr));
		}
  }

  @override
  Future<Either<Failures, NoParams>> setUserCompanySortSettings(List<String> companiesSort) async{
		if(await networkInfo.isConnected){
			try{
				await statisticsRemoteDataSource.setUserSortSettings(companiesSort);
				return Right(NoParams());
			} on ServerException{
				return Left(ServerFailure(msg: 'error'.tr));
			}
		} else {
			return Left(CashFailure(msg: 'error'.tr));
		}
  }

}
