import 'package:LandlordStatistics/config/arguments/routes_arguments.dart';
import 'package:LandlordStatistics/feature/login/presentation/screen/login_screen.dart';
import 'package:LandlordStatistics/feature/setting/presentation/screen/setting_screen.dart';
import 'package:LandlordStatistics/feature/splash/presentation/screen/splash_screen.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/screens/statistic_details_screen.dart';
import 'package:LandlordStatistics/feature/statistics/presentation/screen/statistic_screen.dart';
import 'package:flutter/material.dart';

class Routes{

  static const String initialRoutes = '/';
  static const String loginRoutes = 'Login';
  static const String statisticRoutes = 'Statistic';
  static const String statisticDetailsRoutes = 'StatisticDetails';
  static const String userAccountsRoutes = 'UserAccounts';

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
          final args = routeSettings.arguments as LoginRoutesArguments;
          return LoginScreen(addOtherMail: args.addOtherMail, isThereUsers: args.isThereExistingUsers,);
        });
      case Routes.statisticRoutes:
        return MaterialPageRoute(builder: (context) {
          return const StatisticScreen();
        });
      case Routes.userAccountsRoutes:
        return MaterialPageRoute(builder: (context) {
          return const SettingScreen();
        });
      case Routes.statisticDetailsRoutes:
        final args = routeSettings.arguments as StatisticDetailsRoutesArguments;
        return MaterialPageRoute(builder: (context) {
          return StatisticDetailsScreen(uniqueId: args.uniqueId, companyName: args.companyName, buildingName: args.buildingName, date: args.date,);
        });
      default:
        return null;
    }
  }
}