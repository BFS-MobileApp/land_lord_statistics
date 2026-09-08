import 'package:flutter/material.dart';
import '../../../../config/PrefHelper/helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/size_utils.dart';

import '../../../../widgets/text_widget.dart';
import 'package:get/get.dart';

class ClaimsListCardItem extends StatefulWidget {
  final String referenceId;
  final String status;
  final String priority;
  final String description;
  final String availableTime;
  final String createdAt;
  final String buildingName;
  final String unitName;
  final VoidCallback? onAssignTap;

  const ClaimsListCardItem({
    super.key,
    required this.referenceId,
    required this.status,
    required this.priority,
    required this.description,
    required this.availableTime,
    required this.createdAt,
    this.onAssignTap,
    required this.buildingName,
    required this.unitName,
  });

  @override
  State<ClaimsListCardItem> createState() => _ClaimsListCardItemState();
}

class _ClaimsListCardItemState extends State<ClaimsListCardItem> {
  // Only allow tapping the status button when the claim is still assignable.
  // Adjust this check to match whatever value your API sends for "unassigned/new".
  bool get _isAssignable =>
      widget.status.toLowerCase() == 'new' ||
          widget.status.toLowerCase() == 'unassigned';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.w),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0.adaptSize),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: widget.referenceId,
                          fontSize: 16.fSize,
                          fontWeight: FontWeight.w600,
                          fontColor: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        SizedBox(height: 3.h),
                        SizedBox(
                          width: 170.w,
                          child: TextWidget(
                            text: widget.unitName,
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.claimListFontColor,
                            maxLine: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8.w),
                    ElevatedButton(
                      onPressed: _isAssignable ? widget.onAssignTap : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Helper.returnScreenStatusColor(widget.status),
                        disabledBackgroundColor:
                        Helper.returnScreenStatusColor(widget.status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 10.h,
                        ),
                        elevation: 0,
                      ),
                      child: TextWidget(
                        text:  widget.status,
                        fontSize: 13.fSize,
                        fontWeight: FontWeight.w600,
                        fontColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                const Divider(thickness: 1, color: AppColors.grey),
                SizedBox(height: 8.h),
                _buildRow(context, 'priority'.tr, widget.priority,
                    valueColor: Helper.getPriorityColor(widget.priority)),
                SizedBox(height: 12.h),
                _buildRow(context, 'type'.tr, widget.description),
                SizedBox(height: 12.h),
                _buildRow(context, 'createdDate'.tr, Helper.formatDateTime(widget.createdAt)),
                SizedBox(height: 12.h),
                _buildRow(context, 'availableTime'.tr, widget.availableTime),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: label,
          fontSize: 12.fSize,
          fontColor: Theme.of(context).textTheme.bodyMedium!.color,
          fontWeight: FontWeight.w500,
        ),
        Flexible(
          child: TextWidget(
            text: value,
            fontSize: 12.fSize,
            fontColor: valueColor ?? Theme.of(context).textTheme.bodyMedium!.color,
            fontWeight: FontWeight.w500,
            maxLine: 2,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}