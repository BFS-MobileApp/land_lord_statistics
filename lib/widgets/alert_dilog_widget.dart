import 'dart:ui';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BlurryDialog extends StatelessWidget {
  final String btYes;
  final String btNo;
  final VoidCallback continueCallBack;
  final String title;

  const BlurryDialog({super.key ,required this.btYes,required  this.btNo,required  this.continueCallBack,required  this.title});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: Text(title.tr),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(35) , bottom: ScreenUtil().setHeight(10)),
              child:InkWell(
                child: Text(btNo.tr , style: const TextStyle(color: AppColors.redAlertColor),),
                onTap: ()=>Navigator.pop(context),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20) , bottom: ScreenUtil().setHeight(10)),
              child: InkWell(
                onTap: continueCallBack,
                child: Text(btYes.tr , style: const TextStyle(color: Colors.green),),
              ),
            ),
          ],
        ));
  }
}