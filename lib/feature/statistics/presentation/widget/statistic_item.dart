import 'package:LandlordStatistics/widgets/aligment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticItem extends StatelessWidget {

  final String itemValue;
  final String image;
  AlignmentWidget alignmentWidget = AlignmentWidget();

  StatisticItem({super.key, required this.itemValue, required this.image});



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(5) , right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10) , bottom: ScreenUtil().setHeight(5)),
      alignment: alignmentWidget.returnAlignment(),
      child: Row(
        children: [
          Image.asset(image , width: ScreenUtil().setWidth(18),height: ScreenUtil().setHeight(18),),
          SizedBox(width: ScreenUtil().setWidth(7),),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
            child: Text(itemValue ,
              softWrap: false,
              maxLines: 2,
              overflow: TextOverflow.ellipsis ,
              style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 14.sp),),
          )
        ],
      ),
    );
  }
}
