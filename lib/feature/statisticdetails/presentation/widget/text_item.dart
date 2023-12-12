import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/widgets/aligment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextItem extends StatelessWidget {
  final String itemName;
  final String itemValue;
  final String image;
  AlignmentWidget alignmentWidget = AlignmentWidget();
  TextItem({super.key , required this.image , required this.itemName , required this.itemValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignmentWidget.returnAlignment(),
      margin: EdgeInsets.symmetric(vertical: 1.sp, horizontal: 5.sp),
      child: Row(
        children: [
          Image.asset(image , width: ScreenUtil().setWidth(18),height: ScreenUtil().setHeight(18),),
          SizedBox(width: ScreenUtil().setWidth(5),),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black45, fontSize: 13.sp , fontWeight: FontWeight.w500),
              children: <TextSpan>[
                TextSpan(text: itemName),
                TextSpan(text: itemValue, style: TextStyle(color: AppColors.black , fontSize: 14.sp , fontWeight: FontWeight.w600))
              ],
            ),
          )
        ],
      ),
    );
  }
}
