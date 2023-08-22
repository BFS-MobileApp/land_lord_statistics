import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlertDialogWidget{

  final BuildContext context;
  final String title;
  final VoidCallback yesOnTap;


  AlertDialogWidget({required this.title, required this.yesOnTap , required this.context});

  void logOutDialog(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(title.tr , style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 15.sp),),
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(10) , left: ScreenUtil().setWidth(8), right: ScreenUtil().setWidth(15)),
                child: InkWell(
                    onTap: yesOnTap,
                    child: Text("yes".tr , style: TextStyle(fontWeight: FontWeight.w700 , fontSize: 14.sp , color: Colors.green),)
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(8),),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(10) , right: ScreenUtil().setWidth(15)),
                child: InkWell(
                    onTap: (){
                      Navigator.of(context).pop(true);
                    },
                    child: Text("no".tr, style: TextStyle(fontWeight: FontWeight.w700 , fontSize: 14.sp , color: Colors.red),)
                ),
              ),
            ],
          );
        });
  }
}