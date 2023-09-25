import 'package:claimizer/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAccountItem extends StatelessWidget {
  final String email;
  final bool isActive;
  const UserAccountItem({super.key , required this.email , required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(email , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16.sp),),
            isActive ? Icon(Icons.check , size: 25.sp , color: AppColors.black,) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
