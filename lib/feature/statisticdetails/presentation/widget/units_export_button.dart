import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/units_model.dart';
import 'units_pdf_export.dart';
import 'units_excel_export.dart';

class UnitsExportButton extends StatelessWidget {
  final List<PropertyUnit> units;

  const UnitsExportButton({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'pdf') {
          await exportUnitsToPdf(units, companyName: units.first.companyName);
        } else if (value == 'excel') {
          await exportUnitsToExcel(units);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'pdf', child: Text('exportPdf'.tr)),
        PopupMenuItem(value: 'excel', child: Text('exportExcel'.tr)),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.file_download_outlined, size: 18),
            const SizedBox(width: 6),
            Text('export'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}