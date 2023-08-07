// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;

  const TextWidget({
    required this.text,
    required this.fontSize,
    this.fontColor,
    this.fontWeight
});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ,
      style: TextStyle(
        fontSize: fontSize.sp ,
        color: fontColor,
        fontWeight: fontWeight
      ),
    );
  }
}
