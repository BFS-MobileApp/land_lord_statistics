import 'package:claimizer/feature/login/presentation/screen/login_screen.dart';
import 'package:claimizer/feature/splash/presentation/screen/splash_screen.dart';
import 'package:claimizer/feature/statistics/presentation/screen/statistic_screen.dart';
import 'package:flutter/material.dart';

class Routes{

  static const String initialRoutes = '/';
  static const String loginRoutes = 'Login';
  static const String statisticRoutes = 'Statistic';
}

class AppRoutes{

  static Route? onGenerateRoute(RouteSettings routeSettings){
    switch (routeSettings.name){
      case Routes.initialRoutes:
        return MaterialPageRoute(builder: (context) {
          return const SplashScreen();
        });
      case Routes.loginRoutes:
        return MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        });
      case Routes.statisticRoutes:
        return MaterialPageRoute(builder: (context) {
          return const StatisticScreen();
        });
      default:
        return null;
    }
  }
}