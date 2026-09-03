import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  AppInfoService._();
  static final AppInfoService instance = AppInfoService._();

  String? version;
  String? buildNumber;

  Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
  }
}