import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/setting/presentation/cubit/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAccountItem extends StatelessWidget {
  final String email;
  final bool isActive;
  final BuildContext ctx;
  const UserAccountItem({super.key , required this.ctx , required this.email , required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(!isActive){
          BlocProvider.of<SettingCubit>(context).changeAccount(email);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
        padding: Helper.getCurrentLocal() == 'AR' ? EdgeInsets.only(right: ScreenUtil().setWidth(5)) : EdgeInsets.only(left: ScreenUtil().setWidth(5)),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : null,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(email , style: TextStyle(color: isActive ? AppColors.whiteColor : AppColors.black , fontWeight: FontWeight.w600 , fontSize: 16.sp),),
            SizedBox(height: ScreenUtil().setHeight(8),),
            Row(
              children: [
                isActive ? Icon(Icons.check , size: 25.sp , color: isActive ? AppColors.whiteColor : AppColors.black,) : Icon(Icons.circle_outlined , size: 20.sp , color: AppColors.black,),
                IconButton(onPressed: (){
                  BlocProvider.of<SettingCubit>(context).removeAccount(email , isActive , ctx);
                }, icon: const Icon(Icons.clear) ,color: isActive ? AppColors.whiteColor : AppColors.black,   iconSize: 25.sp,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
