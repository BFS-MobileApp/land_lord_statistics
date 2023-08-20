import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {

  static setItemColor(String key , String value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static Future<Color> getItemColor(String key) async{
    String color = '';
    Color selectedColor = const Color(0xFFFF9500);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey(key)){
      color = preferences.getString(key).toString();
      int value = int.parse(color);
      selectedColor = Color(value).withOpacity(1);
    }
    return selectedColor;
  }

}