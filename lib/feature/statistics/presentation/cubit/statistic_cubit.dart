import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/feature/statistics/domain/entites/statistic.dart';
import 'package:claimizer/feature/statistics/domain/usecases/statistic_use_case.dart';
import 'package:claimizer/feature/statistics/domain/usecases/user_settings_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {

  final StatisticUseCase statisticUseCase;
  final UserSettingsUseCase statisticCompanySettings;
  StatisticCubit({required this.statisticUseCase , required this.statisticCompanySettings}) : super(StatisticInitial());

  Future<void> getData() async{
    emit(StatisticsIsLoading());
    Either<Failures , Statistic> response = await statisticUseCase(NoParams());
    emit(response.fold((failures) => StatisticsError(msg: mapFailureToMsg(failures)), (statistic) => StatisticsLoaded(statistic: statistic)));
  }

  Future<void> setSettings(String color , int sort , String uniqueId) async{
    await statisticCompanySettings(StatisticCompanySettings(color: color ,  sort: sort , uniqueId: uniqueId));

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
