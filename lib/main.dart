import 'package:LandlordStatistics/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';
import 'config/PrefHelper/prefs.dart';
import 'config/app_info/app_info_service.dart';
import 'injection_container.dart' as di;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.instance.init();
  await Prefs.init();
  await di.init();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

