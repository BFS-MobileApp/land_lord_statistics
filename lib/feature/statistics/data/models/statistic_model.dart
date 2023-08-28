// To parse this JSON data, do
//
//     final statisticModel = statisticModelFromJson(jsonString);

import 'dart:convert';

import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/statistics/domain/entites/statistic.dart';
import 'package:flutter/material.dart';

StatisticModel statisticModelFromJson(String str) => StatisticModel.fromJson(json.decode(str));

String statisticModelToJson(StatisticModel data) => json.encode(data.toJson());

class StatisticModel extends Statistic{
  int status;
  Data data;

  StatisticModel({
    required this.status,
    required this.data,
  }) : super(statisticData: data.statisticSummary);

  factory StatisticModel.fromJson(Map<String, dynamic> json) => StatisticModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  List<StatisticSummary> statisticSummary;
  int count;

  Data({
    required this.statisticSummary,
    required this.count,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    statisticSummary: List<StatisticSummary>.from(json["statisticSummary"].map((x) => StatisticSummary.fromJson(x))),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "statisticSummary": List<dynamic>.from(statisticSummary.map((x) => x.toJson())),
    "count": count,
  };
}

class StatisticSummary {
  int statisticsId;
  DateTime statisticsDate;
  String statisticsType;
  String companyName;
  String companyNameAr;
  dynamic companyIdClaimizer;
  dynamic companyEmailClaimizer;
  dynamic buildingIdClaimizer;
  int companyIdFalcon;
  int? buildingIdFalcon;
  String buildingName;
  String buildingNameA;
  String cityName;
  String cityNameA;
  String databaseName;
  String totalUnits;
  String? totalAvailable;
  String? totalBooked;
  String totalOccupied;
  String activeContracts;
  String expiredContracts;
  String? legalCases;
  String bounceCheques;
  String dueCheques;
  String pdcCheques;
  String? next30DaysRenewals;
  dynamic todaySold;
  String? todayBooked;
  String? todayRented;
  String? todayRenewed;
  String? todayVacated;
  String? todayTotalCollections;
  String? todayCashCollections;
  String occupancyStatus;
  String? cashOnHand;
  String? bankBalance;
  String? next15DaysIssuedCheques;
  String? next30DaysServiceContracts;
  dynamic bfsDate;
  String uniqueValue;
  dynamic colorValue;
  dynamic sortValue;

  StatisticSummary({
    required this.statisticsId,
    required this.statisticsDate,
    required this.statisticsType,
    required this.companyName,
    required this.companyNameAr,
    this.companyIdClaimizer,
    this.companyEmailClaimizer,
    this.buildingIdClaimizer,
    required this.companyIdFalcon,
    this.buildingIdFalcon,
    required this.buildingName,
    required this.buildingNameA,
    required this.cityName,
    required this.cityNameA,
    required this.databaseName,
    required this.totalUnits,
    this.totalAvailable,
    this.totalBooked,
    required this.totalOccupied,
    required this.activeContracts,
    required this.expiredContracts,
    this.legalCases,
    required this.bounceCheques,
    required this.dueCheques,
    required this.pdcCheques,
    this.next30DaysRenewals,
    this.todaySold,
    this.todayBooked,
    this.todayRented,
    this.todayRenewed,
    this.todayVacated,
    this.todayTotalCollections,
    this.todayCashCollections,
    required this.occupancyStatus,
    this.cashOnHand,
    this.bankBalance,
    this.next15DaysIssuedCheques,
    this.next30DaysServiceContracts,
    this.bfsDate,
    required this.uniqueValue,
    required this.colorValue,
    required this.sortValue,
  });

  factory StatisticSummary.fromJson(Map<String, dynamic> json) => StatisticSummary(
    statisticsId: json["statistics_id"],
    statisticsDate: DateTime.parse(json["Statistics_Date"]),
    statisticsType: json["statistics_type"]??'',
    companyName: json["Company_name"]??'',
    companyNameAr: json["Company_name_ar"]??'',
    companyIdClaimizer: json["Company_id_claimizer"],
    companyEmailClaimizer: json["Company_email_claimizer"]??'',
    buildingIdClaimizer: json["Building_id_claimizer"]??'',
    companyIdFalcon: json["Company_id_falcon"]??'',
    buildingIdFalcon: json["Building_id_falcon"]??0,
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
    next15DaysIssuedCheques: json["Next_15Days_IssuedCheques"],
    next30DaysServiceContracts: json["Next_30Days_ServiceContracts"],
    bfsDate: json["bfs_date"],
    uniqueValue: json["unique_value"],
    colorValue: json['color_value'],
    sortValue: json['sort_value']
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
    "unique_value": uniqueValue,
    "sort_value":sortValue,
    "color_value":colorValue
  };
}

