import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextItem extends StatelessWidget {
  final String itemName;
  final String itemValue;
  const TextItem({super.key , required this.itemName , required this.itemValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(vertical: 1.sp, horizontal: 5.sp),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 15.sp , fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(text: itemName),
            TextSpan(text: itemValue, style: TextStyle(fontSize: 17.sp , fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
