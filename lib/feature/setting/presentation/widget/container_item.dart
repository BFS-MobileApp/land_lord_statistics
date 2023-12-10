import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ContainerItem extends StatelessWidget {
  Widget itemWidget;
  double height;
  ContainerItem({Key? key , required this.itemWidget , required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8) , vertical: ScreenUtil().setHeight(8)),
      width: MediaQuery.of(context).size.width,
      height: ScreenUtil().setHeight(height),
      color: AppColors.containerColor,
      child: itemWidget,
    );
  }
}
