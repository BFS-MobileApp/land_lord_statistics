import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'statistic_item.dart';

class StatisticWidgetItem extends StatelessWidget {
  final String buildingName;
  final String companyName;
  final String date;

  StatisticWidgetItem({super.key, required this.companyName, required this.date , required this.buildingName});

  final TextStyle fontStyle = TextStyle(fontWeight: FontWeight.w600 , color: AppColors.black , fontSize: 17.sp);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin:const EdgeInsets.symmetric(vertical: 10 , horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.colors[Helper.index(7)].withOpacity(0.35),
          borderRadius:const  BorderRadius.all(Radius.circular(15.0)),
        ),
        height: buildingName == '' ? ScreenUtil().setHeight(70) : ScreenUtil().setHeight(100),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            StatisticItem(itemKey: 'comapny'.tr , itemValue: companyName),
            buildingName == '' ? const SizedBox() : StatisticItem(itemKey: 'buildingName'.tr , itemValue: buildingName),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10)),
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'statisticDate'.tr}: $date' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w600 , fontSize: 13.sp),),
                  Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                    width: ScreenUtil().setWidth(30),
                    height: ScreenUtil().setHeight(30),
                    decoration:  BoxDecoration(
                        color: AppColors.colors[Helper.index(7)].withOpacity(0.35),
                        shape: BoxShape.circle,
                  ),
                    child:  buildingName == '' ? Center(child: Text(Helper.returnFirstChars(companyName) , style: fontStyle,),) : Center(child: Text(Helper.returnFirstChars(buildingName) , style: fontStyle)),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
