import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {

  static setItemColor(String key , int value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  static Future<Color> getItemColor(String key) async{
    int colorValue = 0;
    Color selectedColor = const Color(0xFF44A4F2);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey(key)){
      colorValue = preferences.getInt(key)!;
      selectedColor = Color(colorValue);
    }
    return selectedColor;
  }

}