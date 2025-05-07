import 'package:LandlordStatistics/config/arguments/routes_arguments.dart';
import 'package:LandlordStatistics/config/routes/app_routes.dart';
import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddAccountWidget extends StatelessWidget {
  const AddAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.pushNamed(context, Routes.loginRoutes , arguments: LoginRoutesArguments(addOtherMail: true , isThereExistingUsers: true)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
        padding: Helper.getCurrentLocal() == 'AR' ? EdgeInsets.only(right: ScreenUtil().setWidth(5)) : EdgeInsets.only(left: ScreenUtil().setWidth(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('addAnotherMail'.tr , style: TextStyle(color: AppColors.black , fontWeight: FontWeight.w600 , fontSize: 16.sp),),
            SizedBox(height: ScreenUtil().setHeight(8),),
            Container(
              decoration:const BoxDecoration(
                  color: AppColors.loginPhaseFontColor,
                  borderRadius: BorderRadius.all(Radius.circular(4))
              ),
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4), vertical: ScreenUtil().setHeight(4)),
              margin: Helper.getCurrentLocal() == 'AR' ? EdgeInsets.only(bottom: ScreenUtil().setHeight(5) , left: ScreenUtil().setWidth(5)) : EdgeInsets.only(bottom: ScreenUtil().setHeight(5) , right: ScreenUtil().setWidth(5)),
              child: Icon(Icons.add , size: 18.sp,color: AppColors.whiteColor,),
            )
          ],
        ),
      ),
    );
  }
}
