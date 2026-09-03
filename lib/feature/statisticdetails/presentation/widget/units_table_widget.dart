import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/units_columns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/units_model.dart';


class UnitsTableWidget extends StatelessWidget {
  final List<PropertyUnit> units;

  const UnitsTableWidget({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF7E24D)),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.black,
            ),
            dataTextStyle: const TextStyle(fontSize: 12, color: Colors.black87),
            columnSpacing: 24,
            dividerThickness: 0.5,
            columns: unitsColumns.map((c) => DataColumn(label: Text(c.header.tr))).toList(),
            rows: units
                .map(
                  (u) => DataRow(
                cells: unitsColumns.map((c) => DataCell(Text(c.getValue(u)))).toList(),
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}