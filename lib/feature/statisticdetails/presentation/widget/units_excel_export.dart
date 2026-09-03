import 'dart:io';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/units_columns.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/units_model.dart';

Future<void> exportUnitsToExcel(List<PropertyUnit> units) async {
  final excel = Excel.createExcel();
  final sheet = excel['Units'];
  excel.setDefaultSheet('Units');

  for (var i = 0; i < unitsColumns.length; i++) {
    final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
    cell.value = TextCellValue(unitsColumns[i].header);
    cell.cellStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#F7E24D'),
    );
  }

  for (var r = 0; r < units.length; r++) {
    for (var c = 0; c < unitsColumns.length; c++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1));
      cell.value = TextCellValue(unitsColumns[c].getValue(units[r]));
    }
  }

  final bytes = excel.encode();
  if (bytes == null) return;

  final dir = await getTemporaryDirectory();
  final path = '${dir.path}/units_${DateTime.now().millisecondsSinceEpoch}.xlsx';
  final file = File(path)..writeAsBytesSync(bytes);

  await Share.shareXFiles([XFile(path)], text: 'Units export');
}