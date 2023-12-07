import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/widgets/aligment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticItem extends StatelessWidget {

  final String itemValue;
  final String itemKey;
  AlignmentWidget alignmentWidget = AlignmentWidget();

  StatisticItem({super.key, required this.itemValue, required this.itemKey});



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(5) , right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10) , bottom: ScreenUtil().setHeight(5)),
      alignment: alignmentWidget.returnAlignment(),
      child: Text('$itemKey: $itemValue' ,
        softWrap: false,
        maxLines: 2,
        overflow: TextOverflow.ellipsis ,
        style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 17.sp),),
    );
  }
}
