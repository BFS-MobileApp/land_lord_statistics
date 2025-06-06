import 'package:LandlordStatistics/core/error/exceptions.dart';
import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/network/network_info.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/datasources/statistic_details_remote_data_source.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/entities/statistic_details.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/repositories/statistic_details_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

class StatisticDetailsRepositoryImpl extends StatisticDetailsRepository {

	final NetworkInfo networkInfo;
	final StatisticDetailsRemoteDataSource statisticDetailsRemoteDataSource;

	StatisticDetailsRepositoryImpl({required this.networkInfo , required this.statisticDetailsRemoteDataSource});

  @override
  Future<Either<Failures, StatisticDetails>> getStatisticDetails(String uniqueId) async{
		if(await networkInfo.isConnected){
			try{
				final response = await statisticDetailsRemoteDataSource.getStatisticDetails(uniqueId);
				return Right(response);
			} on ServerException{
				return Left(ServerFailure(msg: 'error'.tr));
			}
		} else {
			return Left(CashFailure(msg: 'connectionError'.tr));
		}
  }

  @override
  Future<Either<Failures, NoParams>> setUserCompanySettings(String color, String uniqueId, double sort) async{
		if(await networkInfo.isConnected){
			try{
				await statisticDetailsRemoteDataSource.setUserSettings(color, uniqueId , sort);
				return Right(NoParams());
			} on ServerException{
				return Left(ServerFailure(msg: 'error'.tr));
			}
		} else {
			return Left(CashFailure(msg: 'error'.tr));
		}
  }

  @override
  Future<Either<Failures, NoParams>> setUserColumnsSettings(List<String> columnsSort) async{
		if(await networkInfo.isConnected){
			try{
				await statisticDetailsRemoteDataSource.setUserColumnSettings(columnsSort);
				return Right(NoParams());
			} on ServerException{
				return Left(ServerFailure(msg: 'error'.tr));
			}
		} else {
			return Left(CashFailure(msg: 'error'.tr));
		}
  }

}
