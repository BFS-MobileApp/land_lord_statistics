import 'dart:async';

import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatefulWidget {

  Widget widget;
  LoadingWidget({super.key , required this.widget});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late Timer _timer;
  bool _isError = false;

  startTimer(){
    _timer = Timer(const Duration(seconds: 5), (){
      Future.delayed(Duration.zero, () async {
        if(mounted){
          setState(() {
            _isError = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  Widget loadingWidget(){
    if(!_isError){
      return const Center(child: CircularProgressIndicator(),);
    } else {
      Timer.run(() => MessageWidget.showSnackBar('error'.tr, AppColors.redAlertColor));
      return widget.widget;
    }
  }
  @override
  Widget build(BuildContext context) {
    return loadingWidget();
  }
}
