import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class MessageWidget{

  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message , Color color){
    final snackBar = SnackBar(
      content: Text(message , style: TextStyle(fontSize: 14.sp , fontWeight: FontWeight.w600),),
      duration: const Duration(seconds: 4),
      backgroundColor: color,
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'ok'.tr,
        onPressed: () {},
      ),
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}