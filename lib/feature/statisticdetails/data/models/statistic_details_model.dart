// To parse this JSON data, do
//
//     final chartModel = chartModelFromJson(jsonString);

import 'dart:convert';
import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/core/utils/hex_color.dart';
import 'package:LandlordStatistics/feature/statisticdetails/domain/entities/statistic_details.dart';
import 'package:flutter/material.dart';

StatisticDetailsModel chartModelFromJson(String str) => StatisticDetailsModel.fromJson(json.decode(str));

String chartModelToJson(StatisticDetailsModel data) => json.encode(data.toJson());

class StatisticDetailsModel extends StatisticDetails {
  int status;
  Data data;

  StatisticDetailsModel({
    required this.status,
    required this.data,
  }) : super(data: data);

  factory StatisticDetailsModel.fromJson(Map<String, dynamic> json) => StatisticDetailsModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Statistics statistics;
  List<StatisticColoumn> statisticColoumns;
  List<Chart> charts;

  Data({
    required this.statistics,
    required this.statisticColoumns,
    required this.charts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    statistics: Statistics.fromJson(json["statistics"]),
    statisticColoumns: List<StatisticColoumn>.from(json["statisticColoumns"].map((x) => StatisticColoumn.fromJson(x))),
    charts: List<Chart>.from(json["charts"].map((x) => Chart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statistics": statistics.toJson(),
    "statisticColoumns": List<dynamic>.from(statisticColoumns.map((x) => x.toJson())),
    "charts": List<dynamic>.from(charts.map((x) => x.toJson())),
  };
}

class Chart {
  int chartId;
  int chartSettingsId;
  int statisticsId;
  List<ChartDatum> chartData;
  FinalApiData finalApiData;
  String type;
  ChartSetting chartSetting;

  Chart({
    required this.chartId,
    required this.chartSettingsId,
    required this.statisticsId,
    required this.chartData,
    required this.finalApiData,
    required this.type,
    required this.chartSetting,
  });

  factory Chart.fromJson(Map<String, dynamic> json) => Chart(
    chartId: json["chart_id"]??0,
    chartSettingsId: json["chart_settings_id"]??0,
    statisticsId: json["statistics_id"]??0,
    chartData: List<ChartDatum>.from(json["chart_data"].map((x) => ChartDatum.fromJson(x))),
    finalApiData: FinalApiData.fromJson(json["final_api_data"] == [] ? [{}] : json["final_api_data"]),
    type: json["type"]??'',
    chartSetting: ChartSetting.fromJson(json["chart_setting"]),
  );

  Map<String, dynamic> toJson() => {
    "chart_id": chartId,
    "chart_settings_id": chartSettingsId,
    "statistics_id": statisticsId,
    "chart_data": List<dynamic>.from(chartData.map((x) => x.toJson())),
    "final_api_data": finalApiData.toJson(),
    "type": type,
    "chart_setting": chartSetting.toJson(),
  };
}

class ChartDatum {
  String ar;
  String en;
  dynamic value;
  String color;

  ChartDatum({
    required this.ar,
    required this.en,
    required this.value,
    required this.color,
  });

  factory ChartDatum.fromJson(Map<String, dynamic> json) => ChartDatum(
    ar: json["ar"]??'',
    en: json["en"]??'',
    value: json["value"]??'',
    color: json["color"]??'',
  );

  Map<String, dynamic> toJson() => {
    "ar": ar,
    "en": en,
    "value": value,
    "color": color,
  };
}

class ChartSetting {
  int id;
  String enName;
  String arName;
  String chartType;

  ChartSetting({
    required this.id,
    required this.enName,
    required this.arName,
    required this.chartType,
  });

  factory ChartSetting.fromJson(Map<String, dynamic> json) => ChartSetting(
    id: json["id"]??0,
    enName: json["en_name"]??'',
    arName: json["ar_name"]??'',
    chartType: json["chart_type"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "en_name": enName,
    "ar_name": arName,
    "chart_type": chartType,
  };
}

class FinalApiData {
  final List<String> labels;
  final List<dynamic> values;
  final List<dynamic> percent;
  final List<String> color;

  FinalApiData({
    required this.labels,
    required this.values,
    required this.percent,
    required this.color,
  });

  factory FinalApiData.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return FinalApiData(
        labels: List<String>.from(json["labels"]),
        values: List<dynamic>.from(json["values"]),
        percent: List<dynamic>.from(json["percent"]),
        color: List<String>.from(json["color"]),
      );
    } else {
      // Handle the case where "final_api_data" is an empty list
      return FinalApiData(
        labels: [],
        values: [],
        percent: [],
        color: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "labels": labels,
      "values": values,
      "percent": percent,
      "color": color,
    };
  }
}


class StatisticColoumn {
  int id;
  String columnName;
  String columnType;
  String enName;
  String arName;
  String iconClass;
  String color;
  double sort;
  String iconSvg;
  Color savedColor;
  String value;
  dynamic userColor;
  dynamic userSort;

  StatisticColoumn({
    required this.id,
    required this.columnName,
    required this.columnType,
    required this.enName,
    required this.arName,
    required this.iconClass,
    required this.color,
    required this.sort,
    required this.iconSvg,
    required this.value,
    required this.savedColor,
    required this.userColor,
    required this.userSort,
  });

  factory StatisticColoumn.fromJson(Map<String, dynamic> json) => StatisticColoumn(
    id: json["id"]??0,
    columnName: json["column_name"]??'',
    columnType: json["column_type"]??'',
    enName: json["en_name"]??'',
    arName: json["ar_name"]??'',
    iconClass: json["icon_class"]??'',
    color: json["color"]??'',
    sort: json["sort"]?.toDouble(),
    iconSvg: json["icon_svg"]??'',
    value: json["value"]??'',
    savedColor: HexColor(json["color"]??''),
    userColor: json['user_color']??'',
    userSort: json['user_sort'] == false ? 0 : json['user_sort']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "column_name": columnName,
    "column_type": columnType,
    "en_name": enName,
    "ar_name": arName,
    "icon_class": iconClass,
    "color": color,
    "sort": sort,
    "icon_svg": iconSvg,
    "value": value,
  };
}

class Statistics {
  int statisticsId;
  DateTime statisticsDate;
  String statisticsType;
  String companyName;
  dynamic companyNameAr;
  dynamic companyIdClaimizer;
  String companyEmailClaimizer;
  dynamic buildingIdClaimizer;
  dynamic companyIdFalcon;
  dynamic buildingIdFalcon;
  String buildingName;
  dynamic buildingNameA;
  dynamic cityName;
  dynamic cityNameA;
  dynamic databaseName;
  String totalUnits;
  String totalAvailable;
  String totalBooked;
  String totalOccupied;
  String activeContracts;
  String expiredContracts;
  String legalCases;
  String bounceCheques;
  String dueCheques;
  String pdcCheques;
  String next30DaysRenewals;
  String todaySold;
  String todayBooked;
  String todayRented;
  dynamic todayRenewed;
  String todayVacated;
  String todayTotalCollections;
  String todayCashCollections;
  String occupancyStatus;
  dynamic cashOnHand;
  dynamic bankBalance;
  dynamic next15DaysIssuedCheques;
  dynamic next30DaysServiceContracts;
  dynamic bfsDate;
  dynamic colorValue;
  dynamic sortValue;

  Statistics({
    required this.statisticsId,
    required this.statisticsDate,
    required this.statisticsType,
    required this.companyName,
    this.companyNameAr,
    this.companyIdClaimizer,
    required this.companyEmailClaimizer,
    this.buildingIdClaimizer,
    this.companyIdFalcon,
    this.buildingIdFalcon,
    required this.buildingName,
    this.buildingNameA,
    this.cityName,
    this.cityNameA,
    this.databaseName,
    required this.totalUnits,
    required this.totalAvailable,
    required this.totalBooked,
    required this.totalOccupied,
    required this.activeContracts,
    required this.expiredContracts,
    required this.legalCases,
    required this.bounceCheques,
    required this.dueCheques,
    required this.pdcCheques,
    required this.next30DaysRenewals,
    required this.todaySold,
    required this.todayBooked,
    required this.todayRented,
    this.todayRenewed,
    required this.todayVacated,
    required this.todayTotalCollections,
    required this.todayCashCollections,
    required this.occupancyStatus,
    this.cashOnHand,
    this.bankBalance,
    this.next15DaysIssuedCheques,
    this.next30DaysServiceContracts,
    this.bfsDate,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    statisticsId: json["statistics_id"]??0,
    statisticsDate: DateTime.parse(json["Statistics_Date"]),
    statisticsType: json["statistics_type"]??'',
    companyName: json["Company_name"]??'',
    companyNameAr: json["Company_name_ar"]??'',
    companyIdClaimizer: json["Company_id_claimizer"]??'',
    companyEmailClaimizer: json["Company_email_claimizer"]??'',
    buildingIdClaimizer: json["Building_id_claimizer"]??'',
    companyIdFalcon: json["Company_id_falcon"]??'',
    buildingIdFalcon: json["Building_id_falcon"]??'',
    buildingName: json["Building_name"]??'',
    buildingNameA: json["building_name_a"]??'',
    cityName: json["city_name"]??'',
    cityNameA: json["city_name_a"]??'',
    databaseName: json["Database_name"]??'',
    totalUnits: json["total_units"]??'',
    totalAvailable: json["total_available"]??'',
    totalBooked: json["total_booked"]??'',
    totalOccupied: json["total_occupied"]??'',
    activeContracts: json["active_contracts"]??'',
    expiredContracts: json["expired_contracts"]??'',
    legalCases: json["legal_cases"]??'',
    bounceCheques: json["bounce_cheques"]??'',
    dueCheques: json["due_cheques"]??'',
    pdcCheques: json["pdc_cheques"]??'',
    next30DaysRenewals: json["Next_30Days_Renewals"]??'',
    todaySold: json["today_sold"]??'',
    todayBooked: json["today_booked"]??'',
    todayRented: json["today_rented"]??'',
    todayRenewed: json["today_renewed"]??'',
    todayVacated: json["today_vacated"]??'',
    todayTotalCollections: json["today_total_collections"]??'',
    todayCashCollections: json["today_cash_collections"]??'',
    occupancyStatus: json["Occupancy_Status"]??'',
    cashOnHand: json["Cash_On_Hand"]??'',
    bankBalance: json["Bank_Balance"]??'',
    next15DaysIssuedCheques: json["Next_15Days_IssuedCheques"]??'',
    next30DaysServiceContracts: json["Next_30Days_ServiceContracts"]??'',
    bfsDate: json["bfs_date"]??'',
  );

  Map<String, dynamic> toJson() => {
    "statistics_id": statisticsId,
    "Statistics_Date": statisticsDate.toIso8601String(),
    "statistics_type": statisticsType,
    "Company_name": companyName,
    "Company_name_ar": companyNameAr,
    "Company_id_claimizer": companyIdClaimizer,
    "Company_email_claimizer": companyEmailClaimizer,
    "Building_id_claimizer": buildingIdClaimizer,
    "Company_id_falcon": companyIdFalcon,
    "Building_id_falcon": buildingIdFalcon,
    "Building_name": buildingName,
    "building_name_a": buildingNameA,
    "city_name": cityName,
    "city_name_a": cityNameA,
    "Database_name": databaseName,
    "total_units": totalUnits,
    "total_available": totalAvailable,
    "total_booked": totalBooked,
    "total_occupied": totalOccupied,
    "active_contracts": activeContracts,
    "expired_contracts": expiredContracts,
    "legal_cases": legalCases,
    "bounce_cheques": bounceCheques,
    "due_cheques": dueCheques,
    "pdc_cheques": pdcCheques,
    "Next_30Days_Renewals": next30DaysRenewals,
    "today_sold": todaySold,
    "today_booked": todayBooked,
    "today_rented": todayRented,
    "today_renewed": todayRenewed,
    "today_vacated": todayVacated,
    "today_total_collections": todayTotalCollections,
    "today_cash_collections": todayCashCollections,
    "Occupancy_Status": occupancyStatus,
    "Cash_On_Hand": cashOnHand,
    "Bank_Balance": bankBalance,
    "Next_15Days_IssuedCheques": next15DaysIssuedCheques,
    "Next_30Days_ServiceContracts": next30DaysServiceContracts,
    "bfs_date": bfsDate,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
