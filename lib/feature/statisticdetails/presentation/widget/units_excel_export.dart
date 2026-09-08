import 'dart:io';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/units_columns.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../data/models/units_model.dart';

/// Returns true if the file was saved, false if the user cancelled.
Future<bool> exportUnitsToExcel(List<PropertyUnit> units) async {
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
  if (bytes == null) return false;

  final fileName = 'units_${DateTime.now().millisecondsSinceEpoch}.xlsx';

  // Opens the native "Save As" picker — user chooses the folder and can
  // rename the file. On Android this uses Storage Access Framework.
  final savedPath = await FilePicker.platform.saveFile(
    dialogTitle: 'Save Excel File',
    fileName: fileName,
    bytes: Uint8List.fromList(bytes), // required on Android/iOS/web
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  return savedPath != null;
}