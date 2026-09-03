import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/statistic_details_model.dart';
import '../../data/models/units_model.dart';

class UnitCardItem extends StatelessWidget {
  final PropertyUnit unit;

  const UnitCardItem({super.key, required this.unit});

  Widget _row(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'occupied':
        return Colors.green;
      case 'vacant':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: property + status pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          unit.propertyName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          unit.buildingName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  if (unit.propertyStatusName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(unit.propertyStatusName!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        unit.propertyStatusName!,
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 1),
              const SizedBox(height: 8),

              // Core details
              _row('company'.tr, unit.companyName),
              _row('type'.tr, unit.typeName),
              _row('usage'.tr, unit.usageName),
              _row('category'.tr, unit.categoryName),
              _row('lease'.tr, unit.leaseFlagName),
              _row('city'.tr, unit.cityName),
              _row('area'.tr, unit.areaName),
              _row('plotNo'.tr, unit.plotNo),

              const SizedBox(height: 8),
              const Divider(thickness: 1),
              const SizedBox(height: 8),

              // Client / contract details
              _row('client'.tr, unit.clientName),
              _row('contractStatus'.tr, unit.contractStatusName),
              _row('startDate'.tr, unit.startDate),
              _row('endDate'.tr, unit.endDate),
              _row('totalRent'.tr, unit.totalRent?.toString()),
            ],
          ),
        ),
      ),
    );
  }
}