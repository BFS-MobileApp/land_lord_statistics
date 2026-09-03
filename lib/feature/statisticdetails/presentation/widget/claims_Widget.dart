import 'package:LandlordStatistics/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../injection_container.dart';
import '../../../../widgets/claims_card_item.dart';
import '../../data/models/statistic_details_model.dart';
import '../screens/claims_list.dart';
import 'app_headline_widget.dart';

class ClaimsWidget extends StatelessWidget {
  final ClaimsData? claimsData;
  final String uniqueId;
  final String buildingName;
  final String companyName;


  const ClaimsWidget({
    super.key,
    this.claimsData,
    required this.uniqueId,
    required this.buildingName,
    required this.companyName,
  });

  void _openClaimsList(BuildContext context, {required String claimStatus, required String title}) {
    if (claimsData == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<StatisticDetailsCubit>(),
          child: ClaimsListScreen(
          uniqueId: uniqueId,
          claimStatus: claimStatus,
          title: title,
          buildingName: buildingName,
          companyName: companyName,
        ),
),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (claimsData == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          AppHeadline(
            title: 'statisticsForYourClaims'.tr,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
          ),
          SizedBox(height: 10.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: HomeCardItem(
                        fontColor: '#ff44A4F2',
                        cardColor: const Color(0xFF44A4F2),
                        title: 'allClaims'.tr,
                        imageIcon: AssetsManager.allClaims,
                        value: claimsData!.statistics.all.toString(),
                        onTap: () => _openClaimsList(context, claimStatus: "", title: 'allClaims'.tr),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: HomeCardItem(
                        cardColor: const Color(0xFFFF9500),
                        fontColor: '#ff9500',
                        title: 'newClaims'.tr,
                        imageIcon: AssetsManager.newClaims,
                        value: claimsData!.statistics.newCount.toString(),
                        onTap: () => _openClaimsList(context, claimStatus: 'New', title: 'newClaims'.tr),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: HomeCardItem(
                        cardColor: const Color(0xFF3716EE),
                        fontColor: '#ff3716ee',
                        title: 'assignedClaims'.tr,
                        imageIcon: AssetsManager.assignedClaims,
                        value: claimsData!.statistics.assigned.toString(),
                        onTap: () => _openClaimsList(context, claimStatus: 'Assigned', title: 'assignedClaims'.tr),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: HomeCardItem(
                        cardColor: const Color(0xFF10D2C8),
                        fontColor: '#ff10d2c8',
                        title: 'startedClaims'.tr,
                        imageIcon: AssetsManager.startedClaims,
                        value: claimsData!.statistics.inProgress.toString(),
                        onTap: () => _openClaimsList(context, claimStatus: 'Started', title: 'startedClaims'.tr),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: HomeCardItem(
                        cardColor: const Color(0xFF0A562E),
                        fontColor: '#ff0a562e',
                        title: 'completedClaims'.tr,
                        imageIcon: AssetsManager.completedClaims,
                        value: claimsData!.statistics.completed.toString(),
                        onTap: () => _openClaimsList(context, claimStatus: 'Completed', title: 'completedClaims'.tr),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: HomeCardItem(
                        cardColor: const Color(0xFFFF0000),
                        fontColor: '#ff0000',
                        title: 'cancelledClaims'.tr,
                        imageIcon: AssetsManager.canceledClaims,
                        value: claimsData!.statistics.cancelled.toString(),
                        onTap: () => _openClaimsList(context, claimStatus: 'Cancelled', title: 'cancelledClaims'.tr),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: HomeCardItem(
                        cardColor: const Color(0xFF679C0D),
                        fontColor: '#ff679c0d',
                        title: 'closedClaims'.tr,
                        imageIcon: AssetsManager.closedClaims,
                        value: claimsData!.statistics.closed.toString(),
                        onTap: () => _openClaimsList(context, claimStatus: 'Closed', title: 'closedClaims'.tr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}