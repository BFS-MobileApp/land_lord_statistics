import 'package:claimizer/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ErrorWidgetItem extends StatelessWidget {

  final VoidCallback onTap;
  const ErrorWidgetItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Icon(Icons.warning_amber_rounded , size: 150.sp, color: AppColors.primaryColor,),
        ),
        Container(
          margin:const EdgeInsets.symmetric(vertical: 12),
          child: Text('somethingWentWrong'.tr , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w700 , fontSize: 20.sp),),
        ),
        Text('pleaseTryAgain'.tr , style:  TextStyle(color: AppColors.grey , fontSize: 18.sp , fontWeight: FontWeight.w500),),
        Container(
          width: context.width*0.55,
          height: ScreenUtil().setHeight(55),
          margin:const EdgeInsets.symmetric(vertical: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Theme.of(context).primaryColor,
                elevation: 500,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                )
            ),
            onPressed: onTap,
            child: Text('reloadScreen'.tr , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white , fontSize: 20.sp),),
          ),
        )
      ],
    );
  }
}
