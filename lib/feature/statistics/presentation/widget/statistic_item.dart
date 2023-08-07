import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StatisticItem extends StatelessWidget {

  final String itemName;

  const StatisticItem({super.key, required this.itemName});



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(8) , right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10)),
      alignment: Alignment.topLeft,
      child: Text('${'company'.tr}: $itemName' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 17.sp),),
    );
  }
}
