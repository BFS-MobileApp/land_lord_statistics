import 'package:claimizer/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';
import 'config/PrefHelper/prefs.dart';
import 'injection_container.dart' as di;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  await di.init();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

