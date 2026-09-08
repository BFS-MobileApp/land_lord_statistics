import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/units_columns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/units_model.dart';

class UnitsTableWidget extends StatelessWidget {
  final List<PropertyUnit> units;

  const UnitsTableWidget({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InteractiveViewer(
        constrained: false,
        minScale: 0.5,
        maxScale: 3.0,
        boundaryMargin: const EdgeInsets.all(80),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.white),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
          dataTextStyle: const TextStyle(fontSize: 13, color: Colors.black87),
          columnSpacing: 28,
          horizontalMargin: 0,
          dividerThickness: 0.6,
          border: const TableBorder(
            horizontalInside: BorderSide(color: Color(0xFFEDEDED), width: 1),
            bottom: BorderSide(color: Color(0xFFDADADA), width: 1),
          ),
          columns: [
            const DataColumn(label: Text('#')),
            ...unitsColumns.map((c) => DataColumn(label: Text(c.header.tr))),
          ],
          rows: List<DataRow>.generate(units.length, (index) {
            final u = units[index];
            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                ...unitsColumns.map((c) => DataCell(Text(c.getValue(u)))),
              ],
            );
          }),
        ),
      ),
    );
  }
}