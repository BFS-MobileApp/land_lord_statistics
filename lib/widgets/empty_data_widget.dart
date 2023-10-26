import 'package:claimizer/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../core/utils/app_colors.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetsManager.noDataImage , width: ScreenUtil().setWidth(80),height: ScreenUtil().setHeight(80),),
          Text('noData'.tr , style: TextStyle(fontSize: 20.sp , color: AppColors.grey , fontWeight: FontWeight.w600),)
        ],
      ),
    );
  }
}
