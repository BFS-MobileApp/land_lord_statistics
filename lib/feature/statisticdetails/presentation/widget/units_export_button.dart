import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/units_model.dart';
import 'units_pdf_export.dart';
import 'units_excel_export.dart';

class UnitsDownloadButtons extends StatelessWidget {
  final List<PropertyUnit> units;

  const UnitsDownloadButtons({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E9E63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              final saved = await exportUnitsToExcel(units);
              if (context.mounted && saved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('fileDownloaded'.tr)),
                );
              }
            },
            icon: const Icon(Icons.download, color: Colors.white),
            label: Text(
              'exportExcel'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC94F4F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              await exportUnitsToPdf(units, companyName: units.first.companyName);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('fileDownloaded'.tr)),
                );
              }
            },
            icon: const Icon(Icons.download, color: Colors.white),
            label: Text(
              'exportPdf'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}