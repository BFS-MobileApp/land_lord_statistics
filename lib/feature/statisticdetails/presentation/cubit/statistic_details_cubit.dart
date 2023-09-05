import 'package:claimizer/core/error/failures.dart';
import 'package:claimizer/core/usecase/use_case.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:claimizer/feature/statisticdetails/domain/usecases/statistic_details_usecase.dart';
import 'package:claimizer/feature/statisticdetails/domain/usecases/user_column_settings_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:claimizer/feature/statisticdetails/domain/entities/statistic_details.dart';
import 'package:equatable/equatable.dart';

part 'statistic_details_state.dart';

class StatisticDetailsCubit extends Cubit<StatisticDetailsState> {

  final StatisticDetailsUseCase statisticDetailsUseCase;
  final UserColumnSettingsUseCase userColumnSettingsUseCase;
  StatisticDetailsCubit({required this.statisticDetailsUseCase , required this.userColumnSettingsUseCase}) : super(StatisticDetailsInitial());

  Future<void> getData(String uniquId) async{
    emit(StatisticsDetailsIsLoading());
    Either<Failures , StatisticDetails> response = await statisticDetailsUseCase(StatisticDetailsParams(uniqueId: uniquId));
    emit(response.fold((failures) => StatisticsDetailsError(msg: mapFailureToMsg(failures)), (res) => StatisticsDetailsLoaded(data: res.data)));
  }

  Future<void> setSettings(String color , double sort , String uniqueId) async{
    await userColumnSettingsUseCase(StatisticColumnSettings(color: color ,  uniqueId: uniqueId , sort: sort));
  }

  Future<void> refreshList(List<StatisticColoumn> statisticList , Data data ) async{
    emit(StatisticDetailsInitialLoading());
    emit(StatisticsDetailsRefresh(statisticList: statisticList , data: data));
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
