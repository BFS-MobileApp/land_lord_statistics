import 'dart:async';
import 'package:LandlordStatistics/config/PrefHelper/dbhelper.dart';
import 'package:LandlordStatistics/config/arguments/routes_arguments.dart';
import 'package:LandlordStatistics/config/routes/app_routes.dart';
import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/assets_manager.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/widgets/logo_widget.dart';
import 'package:LandlordStatistics/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../widgets/force_update_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  late SharedPreferences prefs;
  bool _showWidget = false;

  startTimer(){
    _timer = Timer(const Duration(seconds: 2), ()=> checkLoggingState());
  }

  checkLoggingState() async{
    final dbHelper = DatabaseHelper.instance;
    final hasUsers = await dbHelper.hasAnyUsers();
    if(hasUsers){
      Navigator.pushReplacementNamed(context, Routes.statisticRoutes);
    } else {
      Navigator.pushReplacementNamed(context, Routes.loginRoutes , arguments: LoginRoutesArguments(addOtherMail: false , isThereExistingUsers: false));
    }
  }

  delayAppearingWidget(){
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _showWidget = true;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    //startTimer();
    Helper.getDefaultLanguage();
    Helper.getCurrentLocal();
    delayAppearingWidget();
    Future.delayed(const Duration(milliseconds: 200), () {
      checkVersion(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
  Future<void> checkVersion(BuildContext context) async {
    final newVersion = NewVersionPlus(
      androidId: 'com.befalcon.landlordstatistics',
      iOSId: '6473172017',
    );

    final status = await newVersion.getVersionStatus();

    debugPrint("Local version: ${status?.localVersion}");
    debugPrint("Store version: ${status?.storeVersion}");
    debugPrint("Can update? ${status?.canUpdate}");

    if (status != null && status.canUpdate) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ForceUpdatePage(updateUrl: status.appStoreLink),
        ),
      );
    } else {
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const LogoWidget(),
      body: _showWidget ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetsManager.logoIcon , height: ScreenUtil().setHeight(65),width: ScreenUtil().setWidth(65),),
            SizedBox(height: ScreenUtil().setHeight(10),),
            TextWidget(text: 'landlordStatistics'.tr,fontSize: 24,fontWeight: FontWeight.bold ,fontColor: AppColors.loginPhaseFontColor,)
          ],
        ),
      ): const SizedBox(),
    );
  }
}
