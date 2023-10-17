import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/config/theme/app_theme.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/core/utils/local_strings.dart';
import 'package:claimizer/feature/login/presentation/cubit/login_cubit.dart';
import 'package:claimizer/feature/setting/presentation/cubit/setting_cubit.dart';
import 'package:claimizer/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:claimizer/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'injection_container.dart' as di;
import 'widgets/message_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<LoginCubit>()),
          BlocProvider(create: (context) => di.sl<StatisticCubit>()),
          BlocProvider(create: (context) => di.sl<StatisticDetailsCubit>()),
          BlocProvider(create: (context) => di.sl<SettingCubit>()),
        ],
        child: ScreenUtilInit(
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
                    debugShowCheckedModeBanner: false,
                    title: AppStrings.appName,
                    onGenerateRoute: AppRoutes.onGenerateRoute,
                    scaffoldMessengerKey: MessageWidget.scaffoldMessengerKey,
                  )
              );
            })
    );
  }
}