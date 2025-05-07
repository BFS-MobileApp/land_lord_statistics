import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SVGImageWidget extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  const SVGImageWidget({Key? key , required this.image , required this.width , required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        image,
        height: ScreenUtil().setHeight(height),
        width: ScreenUtil().setWidth(width),
    );
  }
}
