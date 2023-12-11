import 'package:LandlordStatistics/config/routes/app_routes.dart';
import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/feature/setting/presentation/cubit/setting_cubit.dart';
import 'package:LandlordStatistics/widgets/alert_dilog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserAccountItem extends StatefulWidget {
  final String email;
  final bool isActive;
  final BuildContext ctx;

  const UserAccountItem({super.key , required this.ctx , required this.email , required this.isActive});

  @override
  State<UserAccountItem> createState() => _UserAccountItemState();
}

class _UserAccountItemState extends State<UserAccountItem> {

  callDeleteAccountDialog(BuildContext context){
    Future.delayed(const Duration(milliseconds: 500), () {
      AlertDialogWidget dialogWidget = AlertDialogWidget(title: 'deleteAccountPhase'.tr, yesOnTap: (){
        BlocProvider.of<SettingCubit>(context).removeAccount(widget.email , widget.isActive , widget.ctx);
      }, context: context);
      dialogWidget.logOutDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(!widget.isActive){
          BlocProvider.of<SettingCubit>(context).changeAccount(widget.email);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.statisticRoutes, (Route<dynamic> route) => false);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
        padding: Helper.getCurrentLocal() == 'AR' ? EdgeInsets.only(right: ScreenUtil().setWidth(5)) : EdgeInsets.only(left: ScreenUtil().setWidth(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.email , style: TextStyle(color: widget.isActive ? AppColors.loginPhaseFontColor : AppColors.black , fontWeight: FontWeight.w600 , fontSize: 16.sp),),
            SizedBox(height: ScreenUtil().setHeight(8),),
            Container(
              decoration:const BoxDecoration(
                color: AppColors.loginPhaseFontColor,
                borderRadius: BorderRadius.all(Radius.circular(4))
              ),
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4), vertical: ScreenUtil().setHeight(4)),
              margin: Helper.getCurrentLocal() == 'AR' ? EdgeInsets.only(bottom: ScreenUtil().setHeight(5) , left: ScreenUtil().setWidth(5)) : EdgeInsets.only(bottom: ScreenUtil().setHeight(5) , right: ScreenUtil().setWidth(5)),
              child: InkWell(
                onTap: ()=>callDeleteAccountDialog(context),
                child: Icon(Icons.delete_outlined , size: 18.sp,color: AppColors.whiteColor,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
