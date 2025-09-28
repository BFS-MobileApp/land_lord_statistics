import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/usecase/use_case.dart';
import 'package:LandlordStatistics/core/utils/app_strings.dart';
import 'package:LandlordStatistics/core/utils/hex_color.dart';
import 'package:LandlordStatistics/feature/statistics/data/models/statistic_model.dart';
import 'package:LandlordStatistics/feature/statistics/domain/entites/statistic.dart';
import 'package:LandlordStatistics/feature/statistics/domain/usecases/statistic_use_case.dart';
import 'package:LandlordStatistics/feature/statistics/domain/usecases/user_comanies_sort_setting.dart';
import 'package:LandlordStatistics/feature/statistics/domain/usecases/user_settings_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../statisticdetails/domain/usecases/statistic_details_usecase.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {

  final StatisticUseCase statisticUseCase;
  final UserSettingsUseCase statisticCompanySettings;
  final UserSettingsDetailsUseCase userSettingsUseCase;
  final UserCompaniesSortSetting userCompaniesSortSetting;
  StatisticCubit({required this.statisticUseCase ,required this.userSettingsUseCase, required this.statisticCompanySettings , required this.userCompaniesSortSetting}) : super(StatisticInitial());

  Future<void> getData() async {
    emit(StatisticsIsLoading());

    final stats = await statisticUseCase(NoParams());

    await stats.fold(
          (failures) async {
        emit(StatisticsError(msg: failures.msg));
      },
          (res) async {
        final data = res.statisticData;

        final settings = await userSettingsUseCase(NoParams());
        settings.fold(
              (failures) => emit(StatisticsError(msg: failures.msg)),
              (settingsData) {
            applyUserSettings(data, settingsData);
            emit(StatisticsLoaded(statistic: Statistic(statisticData: data)));
          },
        );
      },
    );
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

  void applyUserSettings(List<StatisticSummary> data, Map<String, dynamic> settings) {

    final List<String> companySort =
    List<String>.from(settings['company_statistic_sort'] ?? []);
    final Map<String, dynamic> companyColors =
    Map<String, dynamic>.from(settings['company_statistic_details'] ?? {});

    // 3) Company sorting
    if (companySort.isNotEmpty && data != null) {
      data.sort((a, b) {
        final indexA = companySort.indexOf(a.uniqueValue);
        final indexB = companySort.indexOf(b.uniqueValue);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });
    }

    // 4) Company colors
    if (data != null) {
      for (var comp in data) {
        if (companyColors.containsKey(comp.uniqueValue)) {
          comp.colorValue = HexColor(companyColors[comp.uniqueValue]['color']);
        }
      }
    }
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
