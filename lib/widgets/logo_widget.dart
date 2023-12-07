import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/utils/helper.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://www.befalcon.com');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: Helper.getCurrentLocal() == 'AR' ? EdgeInsets.only(right: MediaQuery.of(context).size.width/2.2 , bottom: ScreenUtil().setHeight(10)) : EdgeInsets.only(left: MediaQuery.of(context).size.width/2.45 , bottom: ScreenUtil().setHeight(10)),
        child: InkWell(
            onTap: _launchUrl,
            child: Text('Be Falcon' , style: TextStyle(fontWeight: FontWeight.bold , color: AppColors.primaryColor , fontSize: 17.sp),)
        ),
      ),
    );
  }
}
