import 'package:claimizer/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartNameItem extends StatelessWidget {

  final Color itemColor;
  final String itemName;
  const ChartNameItem({super.key , required this.itemColor , required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: ScreenUtil().setHeight(12),
          width: ScreenUtil().setWidth(12),
          margin: EdgeInsets.all(10.0.sp),
          decoration: BoxDecoration(
              color: itemColor.withOpacity(0.35),
              shape: BoxShape.circle
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(5),),
        Align(
          alignment: Alignment.center,
          child: Text(itemName , style: TextStyle(fontSize: 12.sp , fontWeight: FontWeight.w400 , color: AppColors.black),),
        )
      ],
    );
  }
}
