import 'package:LandlordStatistics/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/assets_manager.dart';
class ForceUpdatePage extends StatelessWidget {
  final String updateUrl; // Store link (Google Play or App Store)

  const ForceUpdatePage({super.key, required this.updateUrl});

  Future<void> _launchStore() async {
    final uri = Uri.parse(updateUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $updateUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetsManager.logoIcon , height: ScreenUtil().setHeight(65),width: ScreenUtil().setWidth(65),),
                    SizedBox(height: ScreenUtil().setHeight(10),),
                    TextWidget(text: 'landlordStatistics'.tr,fontSize: 24,fontWeight: FontWeight.bold ,fontColor: AppColors.loginPhaseFontColor,)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Icon(Icons.system_update, size: 100,color:  AppColors.primaryColor),
                    const SizedBox(height: 24),
                    const Text(
                      "Update Required",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "A new version of the app is available. You must update to continue using the app.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _launchStore,
                      icon: Icon(Icons.open_in_new,color: Colors.white),
                      label: const Text("Update Now",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        textStyle: const TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

