import 'package:LandlordStatistics/core/utils/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseUrlService {
  String baseUrl = '';

  Future<void> setUrl(String url) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.savedUrl, url);
  }
}
