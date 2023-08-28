import 'package:claimizer/core/error/exceptions.dart';
import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/network/network_info.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/feature/statistics/data/datasources/statistics_remote_data_source.dart';
import 'package:claimizer/feature/statistics/domain/entites/statistic.dart';
import 'package:claimizer/feature/statistics/domain/repositories/statistics_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

class StatisticsRepositoryImpl extends StatisticsRepository {

	final NetworkInfo networkInfo;
	final StatisticsRemoteDataSource statisticsRemoteDataSource;
	StatisticsRepositoryImpl({required this.networkInfo , required this.statisticsRemoteDataSource});

  @override
  Future<Either<Failures, Statistic>> getStatistic() async{
		if(await networkInfo.isConnected){
			try{
				final response =await statisticsRemoteDataSource.getStatisticData();
				return Right(response);
			} on ServerException{
				return Left(ServerFailure(msg: 'error'.tr));
			}
		} else {
			return Left(CashFailure(msg: 'error'.tr));
		}
  }

  @override
  Future<Either<Failures, NoParams>> setUserCompanySettings(String color , int sort , String uniqueId) async{
		if(await networkInfo.isConnected){
			try{
				final response = await statisticsRemoteDataSource.setUserSettings(color, sort, uniqueId);
				return Right(NoParams());
			} on ServerException{
				return Left(ServerFailure(msg: 'error'.tr));
			}
		} else {
			return Left(CashFailure(msg: 'error'.tr));
		}
  }

}
