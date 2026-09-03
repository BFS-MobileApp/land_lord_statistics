import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_info/app_info_service.dart';


class LogoWidget extends StatelessWidget {

  const LogoWidget({
    super.key,
  });

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://www.befalcon.com');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localVersion = AppInfoService.instance.version ?? '';
    return BottomAppBar(
      height: ScreenUtil().setHeight(90),
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: _launchUrl,
        child: Column(
          children: [
            Text('from'.tr , style: TextStyle(fontWeight: FontWeight.w400 , color: const Color(0xFF808080) , fontSize: 12.sp),),
            Text('beFalconSolutions'.tr , style: TextStyle(fontWeight: FontWeight.w800 , color: AppColors.black , fontSize: 14.sp),),
            Text('www.befalcon.com' , style: TextStyle(fontWeight: FontWeight.w600 , color: AppColors.loginPhaseFontColor , fontSize: 12.sp),),
            Text('${'Version'.tr} $localVersion', style: TextStyle(fontWeight: FontWeight.w400 , color: const Color(0xFF808080) , fontSize: 12.sp),),

          ],
        ),
      ),
    );
  }
}
