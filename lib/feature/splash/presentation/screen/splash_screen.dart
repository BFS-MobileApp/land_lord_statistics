import 'dart:async';

import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  goNext() =>Navigator.pushReplacementNamed(context, Routes.loginRoutes);

  startTimer(){
    _timer = Timer(const Duration(seconds: 2), ()=> goNext());
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
        child: Image.asset(AssetsManager.imageIcon , height: ScreenUtil().setHeight(45),width: ScreenUtil().setWidth(45),),
      ),
    );
  }
}
