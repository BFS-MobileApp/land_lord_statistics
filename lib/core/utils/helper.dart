import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';


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
      result.add(words[i][0]);
    }
    String resultString = result.join();
    return resultString;
  }

  static String getCurrentLocal(){
    String local = '';
    final currentLocal = Get.locale;
    local = currentLocal!.countryCode!;
    return local;
  }

}