import 'dart:math';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StatisticWidgetItem extends StatelessWidget {
  final String buildingName;
  final String companyName;
  final String date;

  const StatisticWidgetItem({super.key, required this.companyName, required this.date , required this.buildingName});

  int index(){
    Random random = Random();
    int randomNumber = random.nextInt(7);
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin:const EdgeInsets.symmetric(vertical: 10 , horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.colors[index()].withOpacity(0.35),
          borderRadius:const  BorderRadius.all(Radius.circular(15.0)),
        ),
        height: ScreenUtil().setHeight(76),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(8) , right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10)),
              alignment: Alignment.topLeft,
              child: Text('${'company'.tr}: $companyName' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 17.sp),),
            ),

            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10)),
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'statisticDate'.tr}: $companyName' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w600 , fontSize: 13.sp),),
                  Container(
                    margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                    child: Image.asset(Core.icons[index()],width: ScreenUtil().setWidth(40),height: ScreenUtil().setHeight(40), ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
