import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;
  final String name;

  const ButtonWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.onTap,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Adjust the value as needed
        ),
        minimumSize: Size(ScreenUtil().setWidth(width), ScreenUtil().setHeight(height)),
        backgroundColor: AppColors.primaryColor,
        textStyle: const TextStyle(color: AppColors.whiteColor,
        ),
      ),
      onPressed: onTap,
      child: Text(
        name,
        style: TextStyle(color: AppColors.whiteColor , fontSize: 16.sp , fontWeight: FontWeight.normal),
      ),
    );
  }
}