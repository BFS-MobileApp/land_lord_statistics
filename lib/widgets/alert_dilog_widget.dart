import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlertDialogWidget{

  final BuildContext context;
  final String title;
  final String phase;
  final VoidCallback yesOnTap;


  AlertDialogWidget({required this.title, required this.yesOnTap , required this.phase , required this.context});

  void logOutDialog(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title.tr , textAlign: TextAlign.center , style: TextStyle(fontWeight: FontWeight.w700 , fontSize: 16.sp),),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(80),
              child: Column(
                children: [
                  Text(phase.tr ,textAlign: TextAlign.center  , style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 14.sp),),
                  SizedBox(height: ScreenUtil().setHeight(10),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: ()=>Navigator.of(context).pop(),
                        child: Container(
                          height: ScreenUtil().setHeight(35),
                          width: ScreenUtil().setWidth(110),
                          decoration: const BoxDecoration(
                              color: AppColors.containerColor,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Center(
                            child: Text('no'.tr , style: TextStyle(fontSize: 14.sp , fontWeight: FontWeight.w400 , color: AppColors.black),),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap:yesOnTap,
                        child: Container(
                          height: ScreenUtil().setHeight(35),
                          width: ScreenUtil().setWidth(110),
                          decoration: const BoxDecoration(
                              color: AppColors.loginPhaseFontColor,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Center(
                            child: Text('yes'.tr , style: TextStyle(fontSize: 14.sp , fontWeight: FontWeight.w400 , color: AppColors.whiteColor),),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          );
        });
  }
}