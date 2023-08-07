import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/config/theme/app_theme.dart';
import 'package:claimizer/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'widgets/message_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context , child){
          return MediaQuery(
              data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: GetMaterialApp(
                translations: LocalStrings(),
                locale: const Locale('en', 'US'),
                fallbackLocale: const Locale('en', 'US'),
                theme: appTheme(),
                title: 'appName'.tr,
                onGenerateRoute: AppRoutes.onGenerateRoute,
                scaffoldMessengerKey: MessageWidget.scaffoldMessengerKey,
              )
          );
        });
  }
}