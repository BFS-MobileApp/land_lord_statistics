import 'dart:math';

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

}