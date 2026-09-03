import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/PrefHelper/helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../widgets/text_widget.dart';

class ClaimsListCardItem extends StatelessWidget {
  final String referenceId;
  final String status;
  final String priority;
  final String description;
  final String availableTime;
  final String createdAt;

  const ClaimsListCardItem({
    super.key,
    required this.referenceId,
    required this.status,
    required this.priority,
    required this.description,
    required this.availableTime,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextWidget(
                        text: referenceId,
                        fontSize: 16.fSize,
                        fontWeight: FontWeight.w600,
                        fontColor: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Helper.returnScreenStatusColor(status),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                        color: Helper.returnScreenStatusColor(status),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: status,
                          fontSize: 12.fSize,
                          fontWeight: FontWeight.w500,
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                TextWidget(
                  text: description,
                  fontSize: 12.fSize,
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.claimListFontColor,
                  maxLine: 2,
                ),
                SizedBox(height: 8.h),
                const Divider(thickness: 1, color: AppColors.grey),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'priority'.tr,
                      fontSize: 12.fSize,
                      fontColor: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w500,
                    ),
                    TextWidget(
                      text: priority,
                      fontSize: 12.fSize,
                      fontColor: Helper.getPriorityColor(priority),
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'createdDate'.tr,
                      fontSize: 12.fSize,
                      fontColor: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w500,
                    ),
                    TextWidget(
                      text: createdAt,
                      fontSize: 12.fSize,
                      fontColor: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w500,
                      maxLine: 2,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'availableTime'.tr,
                      fontSize: 12.fSize,
                      fontColor: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w500,
                    ),
                    TextWidget(
                      text: availableTime,
                      fontSize: 12.fSize,
                      fontColor: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w500,
                      maxLine: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}