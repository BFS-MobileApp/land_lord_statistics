import 'dart:convert';
import 'package:LandlordStatistics/core/error/failures.dart';
import 'package:LandlordStatistics/core/utils/app_strings.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/usecases/statistic_details_usecase.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/usecases/user_column_settings_use_case.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/usecases/user_columns_sort_settings.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/statistic_details.dart';

part 'statistic_details_state.dart';

class StatisticDetailsCubit extends Cubit<StatisticDetailsState> {
  final StatisticDetailsUseCase statisticDetailsUseCase;
  final UserColumnSettingsUseCase userColumnSettingsUseCase;
  final UserSettingsDetailsUseCase userSettingsUseCase;
  final UserColumnSortSettingsUseCase userColumnSortSettingsUseCase;

  StatisticDetailsCubit({
    required this.userColumnSortSettingsUseCase,
    required this.statisticDetailsUseCase,
    required this.userColumnSettingsUseCase,
    required this.userSettingsUseCase
  }) : super(StatisticDetailsInitial());

  /// 🔹 Get statistics + apply user settings in one call
  Future<void> getData(String uniqueId) async {
    emit(StatisticsDetailsIsLoading());

    final stats = await statisticDetailsUseCase(StatisticDetailsParams(uniqueId: uniqueId));

    await stats.fold(
          (failures) async {
        emit(StatisticsDetailsError(msg: failures.msg));
      },
          (res) async {
        final data = res.data;

        final settings = await userSettingsUseCase(NoParams());
        settings.fold(
              (failures) => emit(StatisticsDetailsError(msg: failures.msg)),
              (settingsData) {
            applyUserSettings(data, settingsData);
            emit(StatisticsDetailsLoaded(data: data));
          },
        );
      },
    );
  }

  Future<void> setSettings(String color, double sort, String uniqueId) async {
    await userColumnSettingsUseCase(
      StatisticColumnSettings(color: color, uniqueId: uniqueId, sort: sort),
    );
  }

  Future<void> setColumnsSettings(List<String> columnsSort) async {
    await userColumnSortSettingsUseCase(
      StatisticColumnSortSettings(columnsSorts: columnsSort),
    );
  }

  Future<void> refreshList(List<StatisticColoumn> statisticList,
      Data data) async {
    emit(StatisticDetailsInitialLoading());
    emit(StatisticsDetailsRefresh(statisticList: statisticList, data: data));
  }
  Future<void> refreshStatistics(
      List<StatisticColoumn> statisticList, Data data) async {
    emit(StatisticDetailsInitialLoading());
    emit(StatisticsDetailsRefreshStatistics(
      statisticList: statisticList,
      data: data,
    ));
  }

  Future<void> refreshReports(
      List<StatisticColoumn> reportsList, Data data) async {
    emit(StatisticDetailsInitialLoading());
    emit(StatisticsDetailsRefreshReports(
      reportsList: reportsList,
      data: data,
    ));
  }




  /// 🔹 Apply user settings (sort + colors)
  void applyUserSettings(Data data, Map<String, dynamic> settings) {
    final List<String> columnSort =
    List<String>.from(settings['column_statistic_sort'] ?? []);
    final Map<String, dynamic> columnColors =
    Map<String, dynamic>.from(settings['column_statistic_details'] ?? {});

    // 1) Column sorting
    if (columnSort.isNotEmpty) {
      data.statisticColoumns.sort((a, b) {
        final indexA = columnSort.indexOf(a.columnName);
        final indexB = columnSort.indexOf(b.columnName);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });
    }

    // 2) Column colors
    for (var col in data.statisticColoumns) {
      if (columnColors.containsKey(col.columnName)) {
        col.userColor = columnColors[col.columnName]['color'];
      }
    }


    String mapFailureToMsg(Failures failures) {
      switch (failures.runtimeType) {
        case ServerFailure:
          return AppStrings.serverError;
        case CashFailure:
          return AppStrings.cacheError;
        default:
          return AppStrings.unexpectedError;
      }
    }
  }
}
