import 'dart:async';
import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  late SharedPreferences prefs;

  startTimer(){
    _timer = Timer(const Duration(seconds: 2), ()=> checkLoggingState());
  }

  checkLoggingState() async{
    prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(AppStrings.token)){
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, Routes.statisticRoutes);
    } else {
      Navigator.pushReplacementNamed(context, Routes.loginRoutes);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AssetsManager.logoIcon , height: ScreenUtil().setHeight(45),width: ScreenUtil().setWidth(45),),
      ),
    );
  }
}
