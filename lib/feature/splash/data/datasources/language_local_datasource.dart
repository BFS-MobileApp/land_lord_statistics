import 'package:claimizer/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LanguageLocalDataSource{

  Future<void> changeLang(String languageCode);
  Future<String?> getSavedLanguage();
}

class LanguageLocalDataSourceImpl implements LanguageLocalDataSource{
  final SharedPreferences sharedPreferences;

  LanguageLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> changeLang(String languageCode) async {
    final currentLocal = Get.locale;
    if(currentLocal!.countryCode == AppStrings.arCountryCode){
      var locale = const Locale('en','US');
      Get.updateLocale(locale);
    } else {
      var locale = const Locale('ar','AR');
      Get.updateLocale(locale);
    }
    debugPrint('datasource'+currentLocal.countryCode.toString());
    await sharedPreferences.setString(AppStrings.local, languageCode);
  }

  @override
  Future<String?> getSavedLanguage() async {
    if(sharedPreferences.containsKey(AppStrings.local)){
      debugPrint('hi ${sharedPreferences.getString(AppStrings.local)}');
      return sharedPreferences.getString(AppStrings.local);
    } else {
      return AppStrings.enCountryCode;
    }
  }

}