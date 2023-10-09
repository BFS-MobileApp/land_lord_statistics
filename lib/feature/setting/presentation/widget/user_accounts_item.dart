import 'package:claimizer/core/utils/app_colors.dart';
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
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(email , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16.sp),),
            SizedBox(height: ScreenUtil().setHeight(8),),
            Row(
              children: [
                isActive ? Icon(Icons.check , size: 25.sp , color: AppColors.black,) : Icon(Icons.circle_outlined , size: 20.sp , color: AppColors.black,),
                IconButton(onPressed: (){
                  BlocProvider.of<SettingCubit>(context).removeAccount(email , isActive , ctx);
                }, icon: const Icon(Icons.clear) , iconSize: 25.sp,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
