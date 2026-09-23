class UnitsModel {
  final List<PropertyUnit> data;
  final UnitsMeta meta;

  UnitsModel({required this.data, required this.meta});

  factory UnitsModel.fromJson(Map<String, dynamic> json) {
    return UnitsModel(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => PropertyUnit.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: UnitsMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class UnitsMeta {
  final UnitsPagination pagination;

  UnitsMeta({required this.pagination});

  factory UnitsMeta.fromJson(Map<String, dynamic> json) {
    return UnitsMeta(
      pagination: UnitsPagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'pagination': pagination.toJson()};
}

class UnitsPagination {
  final int total;
  final int count;
  final int perPage;
  final int currentPage;
  final int totalPages;

  UnitsPagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
  });

  factory UnitsPagination.fromJson(Map<String, dynamic> json) {
    return UnitsPagination(
      total: json['total'] ?? 0,
      count: json['count'] ?? 0,
      perPage: json['per_page'] ?? 0,
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'count': count,
    'per_page': perPage,
    'current_page': currentPage,
    'total_pages': totalPages,
  };
}

class PropertyUnit {
  final int id;
  final String companyName;
  final String companyNameAr;
  final int companyIdFalcon;
  final int propertyId;
  final int buildingId;
  final String buildingName;
  final String buildingNameA;
  final String propertyNumber;
  final String propertyName;
  final String propertyNameA;
  final String? propertyStatusName;
  final String? propertyStatusNameA;
  final String? typeName;
  final String? typeNameA;
  final String? modelName;
  final String? modelNameA;
  final String? usageName;
  final String? usageNameA;
  final String? categoryName;
  final String? categoryNameA;
  final String? veiwName;
  final String? veiwNameA;
  final String? positionName;
  final String? positionNameA;
  final String? leaseFlagName;
  final String? leaseFlagNameA;
  final String? cityName;
  final String? cityNameA;
  final String? areaName;
  final String? areaNameA;
  final String? plotNo;
  final String? ownerName;
  final String? ownerNameA;
  final String? ownerNationality;
  final String? ownerNationalityA;
  final int? contractNoLast;
  final String? contractStatusName;
  final String? contractStatusNameA;
  final String? contractCaseName;
  final String? contractCaseNameA;
  final String? startDate;
  final String? endDate;
  final int? noOfDays;
  final num? netRent;
  final num? securityAmount;
  final int? noOfUnits;
  final int? noOfInstallments;
  final num? rentValue;
  final num? discount;
  final num? totalRent;
  final String? clientName;
  final String? clientNameA;
  final String? clientNationality;
  final String? clientEmail;
  final String? clientMobile;
  final String? clientIdNo;

  PropertyUnit({
    required this.id,
    required this.companyName,
    required this.companyNameAr,
    required this.companyIdFalcon,
    required this.propertyId,
    required this.buildingId,
    required this.buildingName,
    required this.buildingNameA,
    required this.propertyNumber,
    required this.propertyName,
    required this.propertyNameA,
    this.propertyStatusName,
    this.propertyStatusNameA,
    this.typeName,
    this.typeNameA,
    this.modelName,
    this.modelNameA,
    this.usageName,
    this.usageNameA,
    this.categoryName,
    this.categoryNameA,
    this.veiwName,
    this.veiwNameA,
    this.positionName,
    this.positionNameA,
    this.leaseFlagName,
    this.leaseFlagNameA,
    this.cityName,
    this.cityNameA,
    this.areaName,
    this.areaNameA,
    this.plotNo,
    this.ownerName,
    this.ownerNameA,
    this.ownerNationality,
    this.ownerNationalityA,
    this.contractNoLast,
    this.contractStatusName,
    this.contractStatusNameA,
    this.contractCaseName,
    this.contractCaseNameA,
    this.startDate,
    this.endDate,
    this.noOfDays,
    this.netRent,
    this.securityAmount,
    this.noOfUnits,
    this.noOfInstallments,
    this.rentValue,
    this.discount,
    this.totalRent,
    this.clientName,
    this.clientNameA,
    this.clientNationality,
    this.clientEmail,
    this.clientMobile,
    this.clientIdNo,
  });

  factory PropertyUnit.fromJson(Map<String, dynamic> json) {
    return PropertyUnit(
      id: json['id'] ?? 0,
      companyName: json['company_name'] ?? '',
      companyNameAr: json['company_name_ar'] ?? '',
      companyIdFalcon: json['company_id_falcon'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      buildingId: json['building_id'] ?? 0,
      buildingName: json['building_name'] ?? '',
      buildingNameA: json['building_name_a'] ?? '',
      propertyNumber: json['property_number']?.toString() ?? '',
      propertyName: json['property_name']?.toString() ?? '',
      propertyNameA: json['property_name_a']?.toString() ?? '',
      propertyStatusName: json['property_status_name'],
      propertyStatusNameA: json['property_status_name_a'],
      typeName: json['type_name'],
      typeNameA: json['type_name_a'],
      modelName: json['model_name'],
      modelNameA: json['model_name_a'],
      usageName: json['usage_name'],
      usageNameA: json['usage_name_a'],
      categoryName: json['category_name'],
      categoryNameA: json['category_name_a'],
      veiwName: json['veiw_name'],
      veiwNameA: json['veiw_name_a'],
      positionName: json['position_name'],
      positionNameA: json['position_name_a'],
      leaseFlagName: json['lease_flag_name'],
      leaseFlagNameA: json['lease_flag_name_a'],
      cityName: json['city_name'],
      cityNameA: json['city_name_a'],
      areaName: json['area_name'],
      areaNameA: json['area_name_a'],
      plotNo: json['plot_no']?.toString(),
      ownerName: json['owner_name'],
      ownerNameA: json['owner_name_a'],
      ownerNationality: json['owner_nationality'],
      ownerNationalityA: json['owner_nationality_a'],
      contractNoLast: json['contract_no_last'],
      contractStatusName: json['contract_status_name'],
      contractStatusNameA: json['contract_status_name_a'],
      contractCaseName: json['contract_case_name'],
      contractCaseNameA: json['contract_case_name_a'],
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? "",
      noOfDays: json['no_of_days'],
      netRent: json['net_rent'],
      securityAmount: json['security_amount'],
      noOfUnits: json['no_of_units'],
      noOfInstallments: json['no_of_installments'],
      rentValue: json['rent_value'],
      discount: json['discount'],
      totalRent: json['total_rent'],
      clientName: json['client_name'],
      clientNameA: json['client_name_a'],
      clientNationality: json['client_nationality'],
      clientEmail: json['client_email'],
      clientMobile: json['client_mobile'],
      clientIdNo: json['client_id_no'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_name': companyName,
    'company_name_ar': companyNameAr,
    'company_id_falcon': companyIdFalcon,
    'property_id': propertyId,
    'building_id': buildingId,
    'building_name': buildingName,
    'building_name_a': buildingNameA,
    'property_number': propertyNumber,
    'property_name': propertyName,
    'property_name_a': propertyNameA,
    'property_status_name': propertyStatusName,
    'property_status_name_a': propertyStatusNameA,
    'type_name': typeName,
    'type_name_a': typeNameA,
    'model_name': modelName,
    'model_name_a': modelNameA,
    'usage_name': usageName,
    'usage_name_a': usageNameA,
    'category_name': categoryName,
    'category_name_a': categoryNameA,
    'veiw_name': veiwName,
    'veiw_name_a': veiwNameA,
    'position_name': positionName,
    'position_name_a': positionNameA,
    'lease_flag_name': leaseFlagName,
    'lease_flag_name_a': leaseFlagNameA,
    'city_name': cityName,
    'city_name_a': cityNameA,
    'area_name': areaName,
    'area_name_a': areaNameA,
    'plot_no': plotNo,
    'owner_name': ownerName,
    'owner_name_a': ownerNameA,
    'owner_nationality': ownerNationality,
    'owner_nationality_a': ownerNationalityA,
    'contract_no_last': contractNoLast,
    'contract_status_name': contractStatusName,
    'contract_status_name_a': contractStatusNameA,
    'contract_case_name': contractCaseName,
    'contract_case_name_a': contractCaseNameA,
    'start_date': startDate,
    'end_date': endDate,
    'no_of_days': noOfDays,
    'net_rent': netRent,
    'security_amount': securityAmount,
    'no_of_units': noOfUnits,
    'no_of_installments': noOfInstallments,
    'rent_value': rentValue,
    'discount': discount,
    'total_rent': totalRent,
    'client_name': clientName,
    'client_name_a': clientNameA,
    'client_nationality': clientNationality,
    'client_email': clientEmail,
    'client_mobile': clientMobile,
    'client_id_no': clientIdNo,
  };
}