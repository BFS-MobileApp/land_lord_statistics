import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartNameItem extends StatelessWidget {

  final Color itemColor;
  final String itemName;
  const ChartNameItem({super.key , required this.itemColor , required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        minLeadingWidth : 1,
        dense:true,
        minVerticalPadding: 1.sp,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        title: Text(itemName  , style: TextStyle(fontSize: 12.sp , fontWeight: FontWeight.w400 , color: AppColors.black),),
        leading: Container(
          //alignment: Alignment.center,
          height: ScreenUtil().setHeight(12),
          width: ScreenUtil().setWidth(12),
          margin: Helper.getCurrentLocal() == 'AR' ? EdgeInsets.only(right: MediaQuery.of(context).size.width/3) : EdgeInsets.only(left: MediaQuery.of(context).size.width/3),
          decoration: BoxDecoration(
              color: itemColor.withOpacity(0.9),
              shape: BoxShape.circle
          ),
        ),
      ),
    );
  }
}
