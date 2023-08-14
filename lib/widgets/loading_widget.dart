import 'dart:async';

import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {

  final VoidCallback onTap;

  const LoadingWidget({super.key, required this.onTap});
  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late Timer _timer;
  bool _isError = false;

  startTimer(){
    _timer = Timer(const Duration(seconds: 5), (){
      Future.delayed(Duration.zero, () async {
        setState(() {
          _isError = true;
        });
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
      return ErrorWidget(widget.onTap);
    }
  }
  @override
  Widget build(BuildContext context) {
    return loadingWidget();
  }
}
