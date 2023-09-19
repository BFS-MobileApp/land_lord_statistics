import 'dart:math';

import 'package:claimizer/config/PrefHelper/shared_pref_helper.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Helper{

  //
  static String convertStringToDateOnly(String date){
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    return formattedDate;
  }

  static int index(int number){
    Random random = Random();
    int randomNumber = random.nextInt(number);
    return randomNumber;
  }

  static String returnFirstChars(String item){
    List<String> words = item.split(' ');
    List<String> result = [];
    for (int i = 0; i < words.length && i < 2; i++) {
      if (words[i].isNotEmpty) {
        result.add(words[i][0]);
      }
    }
    String resultString = result.join();
    return resultString;
  }

  static String getCurrentLocal(){
    String local = AppStrings.enCountryCode;
    final currentLocal = Get.locale;
    local = currentLocal!.countryCode!;
    return local;
  }

  static setDefaultLang(String lang) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(AppStrings.local, lang);
  }

  static getDefaultLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String language = AppStrings.enCountryCode;
    if(preferences.containsKey(AppStrings.local)){
      language = preferences.getString(AppStrings.local).toString();
    }
    if(language == AppStrings.enCountryCode){
      var locale = const Locale('en', 'US');
      Get.updateLocale(locale);
    } else {
      var locale = const Locale('ar', 'AR');
      Get.updateLocale(locale);
    }
  }

}