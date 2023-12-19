import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://www.befalcon.com');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: ScreenUtil().setHeight(72),
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: _launchUrl,
        child: Column(
          children: [
            Text('From'.tr , style: TextStyle(fontWeight: FontWeight.w400 , color: const Color(0xFF808080) , fontSize: 12.sp),),
            Text('Be Falcon Solutions' , style: TextStyle(fontWeight: FontWeight.w800 , color: AppColors.black , fontSize: 14.sp),),
            Text('www.befalcon.com' , style: TextStyle(fontWeight: FontWeight.w600 , color: AppColors.loginPhaseFontColor , fontSize: 12.sp),),
          ],
        ),
      ),
    );
  }
}
