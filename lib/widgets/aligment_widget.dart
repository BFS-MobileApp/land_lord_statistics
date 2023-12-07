import 'package:LandlordStatistics/core/utils/app_strings.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:flutter/cupertino.dart';

abstract class AlignmentType{

  Alignment returnAlignment();

}

class AlignmentWidget extends AlignmentType{
  @override
   Alignment returnAlignment() {
    if(Helper.getCurrentLocal()==AppStrings.arCountryCode){
      return Alignment.topRight;
    } else {
      return Alignment.topLeft;
    }
  }

}