import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/core/utils/app_strings.dart';
import 'package:LandlordStatistics/feature/statistics/data/models/statistic_model.dart';
import 'package:LandlordStatistics/feature/statistics/domain/entites/statistic.dart';
import 'package:LandlordStatistics/feature/statistics/domain/usecases/statistic_use_case.dart';
import 'package:LandlordStatistics/feature/statistics/domain/usecases/user_comanies_sort_setting.dart';
import 'package:LandlordStatistics/feature/statistics/domain/usecases/user_settings_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {

  final StatisticUseCase statisticUseCase;
  final UserSettingsUseCase statisticCompanySettings;
  final UserCompaniesSortSetting userCompaniesSortSetting;
  StatisticCubit({required this.statisticUseCase , required this.statisticCompanySettings , required this.userCompaniesSortSetting}) : super(StatisticInitial());

  Future<void> getData() async{
    emit(StatisticsIsLoading());
    Either<Failures , Statistic> response = await statisticUseCase(NoParams());
    emit(response.fold((failures) => StatisticsError(msg: mapFailureToMsg(failures)), (statistic) => StatisticsLoaded(statistic: statistic)));
  }

  Future<void> setSettings(String color , double sort , String uniqueId) async{
    await statisticCompanySettings(StatisticCompanySettings(color: color ,  sort: sort , uniqueId: uniqueId));
  }

  Future<void> setCompanySort(List<String> companies) async{
    await userCompaniesSortSetting(StatisticCompanySortSettings(companiesSort: companies));
  }

  Future<void> refreshList(List<StatisticSummary> statisticList) async{
    emit(StatisticInitial());
    emit(StatisticsRefresh(statisticList: statisticList));
  }


  String mapFailureToMsg(Failures failures){
    switch (failures.runtimeType){
      case ServerFailure:
        return AppStrings.serverError;
      case CashFailure:
        return AppStrings.cacheError;
      default:
        return AppStrings.unexpectedError;
    }
  }
}
