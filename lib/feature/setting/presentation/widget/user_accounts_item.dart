import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/setting/presentation/cubit/setting_cubit.dart';
import 'package:claimizer/widgets/alert_dilog_widget.dart';
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
  bool showDeleteIcon = false;

  callDeleteAccountDialog(BuildContext context){
    Future.delayed(const Duration(milliseconds: 500), () {
      AlertDialogWidget dialogWidget = AlertDialogWidget(title: 'deleteAccountPhase'.tr, yesOnTap: (){
        BlocProvider.of<SettingCubit>(context).removeAccount(widget.email , widget.isActive , widget.ctx);
      }, context: context);
      dialogWidget.logOutDialog();
    });
  }

  @override
  void dispose() {
    showDeleteIcon = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: (){
        setState(() {
          showDeleteIcon = !showDeleteIcon;
        });
      },
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
        decoration: BoxDecoration(
          color: widget.isActive ? AppColors.primaryColor : null,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.email , style: TextStyle(color: widget.isActive ? AppColors.whiteColor : AppColors.black , fontWeight: FontWeight.w600 , fontSize: 16.sp),),
            SizedBox(height: ScreenUtil().setHeight(8),),
            Container(
              margin: Helper.getCurrentLocal() == 'AR' ? EdgeInsets.only(bottom: ScreenUtil().setHeight(5) , left: ScreenUtil().setWidth(5)) : EdgeInsets.only(bottom: ScreenUtil().setHeight(5) , right: ScreenUtil().setWidth(5)),
              child: Row(
                children: [
                  widget.isActive ? Icon(Icons.check , size: 25.sp , color: widget.isActive ? AppColors.whiteColor : AppColors.black,) : Icon(Icons.circle_outlined , size: 20.sp , color: AppColors.black,),
                  GestureDetector(
                    child: showDeleteIcon ? Icon(Icons.delete  , color: widget.isActive ? AppColors.whiteColor : AppColors.red, size: 25.sp,) : SizedBox(),
                    onTap: (){ callDeleteAccountDialog(context); },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
