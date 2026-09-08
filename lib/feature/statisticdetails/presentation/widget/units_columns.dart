import '../../data/models/units_model.dart';
import '../../../../core/utils/helper.dart'; // adjust path to match your Helper import

class UnitColumn {
  final String header;
  final String Function(PropertyUnit) getValue;

  const UnitColumn(this.header, this.getValue);
}

bool get _isArabic => Helper.getCurrentLocal() == 'AR';

String _s(String? v) => (v == null || v.isEmpty) ? '-' : v;
String _n(num? v) => v == null ? '-' : v.toString();

/// Picks the Arabic field when the app locale is AR, falling back to
/// English if the Arabic value is null/empty (some fields, like owner
/// info, come back as "!" or null in Arabic in real responses).
String _loc(String? en, String? ar) {
  if (_isArabic && ar != null && ar.isNotEmpty) return ar;
  return _s(en);
}

final List<UnitColumn> unitsColumns = [
  UnitColumn('company', (u) => _loc(u.companyName, u.companyNameAr)),
  UnitColumn('building', (u) => _loc(u.buildingName, u.buildingNameA)),
  UnitColumn('propertyNumber', (u) => _loc(u.propertyNumber, u.propertyNumber)),
  UnitColumn('propertyName', (u) => _loc(u.propertyName, u.propertyNameA)),
  UnitColumn('status', (u) => _loc(u.propertyStatusName, u.propertyStatusNameA)),
  UnitColumn('propertyType', (u) => _loc(u.typeName, u.typeNameA)),
  // UnitColumn('model', (u) => _loc(u.modelName, u.modelNameA)),
  UnitColumn('usage', (u) => _loc(u.usageName, u.usageNameA)),
  UnitColumn('category', (u) => _loc(u.categoryName, u.categoryNameA)),
  UnitColumn('view', (u) => _loc(u.veiwName, u.veiwNameA)),
  UnitColumn('position', (u) => _loc(u.positionName, u.positionNameA)),
  UnitColumn('lease', (u) => _loc(u.leaseFlagName, u.leaseFlagNameA)),
  UnitColumn('city', (u) => _loc(u.cityName, u.cityNameA)),
  UnitColumn('area', (u) => _loc(u.areaName, u.areaNameA)),
  UnitColumn('plotNo', (u) => _s(u.plotNo)),
  UnitColumn('owner', (u) => _loc(u.ownerName, u.ownerNameA)),
  UnitColumn('ownerNationality', (u) => _loc(u.ownerNationality, u.ownerNationalityA)),
  UnitColumn('contractNo', (u) => u.contractNoLast?.toString() ?? '-'),
  UnitColumn('contractStatus', (u) => _loc(u.contractStatusName, u.contractStatusNameA)),
  UnitColumn('contractCase', (u) => _loc(u.contractCaseName, u.contractCaseNameA)),
  UnitColumn('startDate', (u) => _s(u.startDate)),
  UnitColumn('endDate', (u) => _s(u.endDate)),
  UnitColumn('netRent', (u) => _n(u.netRent)),
  UnitColumn('securityAmount', (u) => _n(u.securityAmount)),
  UnitColumn('totalRent', (u) => _n(u.totalRent)),
  UnitColumn('clientName', (u) => _loc(u.clientName, u.clientNameA)),
  UnitColumn('clientNationality', (u) => _s(u.clientNationality)), // no _a variant in response
  UnitColumn('clientEmail', (u) => _s(u.clientEmail)),
  UnitColumn('clientMobile', (u) => _s(u.clientMobile)),
];