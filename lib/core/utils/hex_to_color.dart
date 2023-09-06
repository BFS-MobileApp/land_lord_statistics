import 'dart:ui';

class HexToColor {

  static Color convertHexToColor(String hexColor){

    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);

  }
}