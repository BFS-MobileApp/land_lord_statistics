import 'dart:async';
import 'dart:io';
import 'package:claimizer/config/PrefHelper/dbhelper.dart';
import 'package:claimizer/config/PrefHelper/prefs.dart';
import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/core/api/end_points.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/assets_manager.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/login/presentation/cubit/login_cubit.dart';
import 'package:claimizer/widgets/button_widget.dart';
import 'package:claimizer/widgets/logo_widget.dart';
import 'package:claimizer/widgets/message_widget.dart';
import 'package:claimizer/widgets/text_widget.dart';
import 'package:claimizer/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {

  bool addOtherMail;
  bool isThereUsers;
  LoginScreen({super.key , required this.addOtherMail , required this.isThereUsers});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isErrorMessageAppeared = false;

   Widget _loginWidget(){
    return Column(
      children: [
        SizedBox(height: ScreenUtil().setHeight(80),),
        InkWell(
          child: Image.asset(AssetsManager.logoIcon, width: ScreenUtil().setWidth(93),height: ScreenUtil().setHeight(95),),
          onLongPress: (){
            if(!widget.addOtherMail && !widget.isThereUsers){
              showBaseUrlAlertDialog(context);
            }
          },
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 15.sp),
            child: TextWidget(text: 'login'.tr,fontSize: 32,)
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10.sp),
            child: TextWidget(text: 'welcomePhase'.tr,fontSize: 17,fontWeight: FontWeight.w500,fontColor: AppColors.grey,)
        ),
        Container(
            alignment: Helper.getCurrentLocal() == 'AR' ? Alignment.topRight: Alignment.topLeft,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10) , right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10)),
            child: TextWidget(text: 'email'.tr,fontSize: 17,)
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          child: TextFieldWidget(height: 8, width: MediaQuery.of(context).size.width, controller: emailController, isPasswordTextField: false, keyboardType: TextInputType.emailAddress),
        ),
        Container(
            alignment: Helper.getCurrentLocal() == 'AR' ? Alignment.topRight: Alignment.topLeft,
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20) , left: ScreenUtil().setWidth(10) , right: ScreenUtil().setWidth(10)),
            child:  TextWidget(text: 'password'.tr,fontSize: 17,)
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          child: TextFieldWidget(height: 8, width: MediaQuery.of(context).size.width, controller: passwordController, isPasswordTextField: true, keyboardType: TextInputType.emailAddress),
        ),
        /*Container(
          alignment: Helper.getCurrentLocal() == 'AR' ? Alignment.topLeft: Alignment.topRight,
          margin: EdgeInsets.symmetric(horizontal: 10.sp , vertical: 10.sp),
          child:  InkWell(
            onTap: (){},
            child: TextWidget(text: 'forgotPassword'.tr, fontSize: 12.sp,fontWeight: FontWeight.w500 , fontColor: AppColors.lightBlue,),
          ),
        ),*/
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.sp , vertical: 20.sp),
          child: ButtonWidget(
              width: MediaQuery.of(context).size.width*0.83,
              height: 45,
              onTap: (){
                login();
              },
              name: 'login'.tr
          ),
        )
      ],
    );
  }

  void login(){
     if(emailController.value.text.isEmpty){
       MessageWidget.showSnackBar('emptyEmail'.tr, AppColors.red);
       return;
     }
     if(passwordController.value.text.isEmpty){
       MessageWidget.showSnackBar('emptyPassword'.tr, AppColors.red);
       return;
     }
     context.read<LoginCubit>().login(emailController.value.text.toString(), passwordController.value.text.toString());
  }

  Future<void> showBaseUrlAlertDialog(BuildContext context) async {
    String groupValue = 'live'; // Get the current setting
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Base URL'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile(
                    title: Text('Live URL'),
                    value: 'live',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Beta URL'),
                    value: 'beta',
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setUrl(groupValue);
                      Navigator.of(context).pop();
                      login();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  setUrl(String value){
    final databaseHelper = DatabaseHelper.instance;
     if(value == 'live'){
       databaseHelper.insertUrl(EndPoints.liveUrl);
     } else if(value == 'beta'){
       databaseHelper.insertUrl(EndPoints.betaUrl);
     }
  }

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().initLoginPage();
    print(widget.addOtherMail);
    print(widget.isThereUsers);
  }
  Widget checkState(LoginState state){
     if(state is LoginIsLoading){
       initialErrorStatus();
      return const Center(child: CircularProgressIndicator(),);
    } else if(state is LoginError){
      showErrorMessage(state.msg);
      return _loginWidget();
    } else if(state is LoginLoaded) {
      clearMultiServerFeature();
      goToNextScreen();
      return const SizedBox();
    } else {
      return _loginWidget();
    }
  }

  clearMultiServerFeature() => Prefs.clear();

  goToNextScreen(){
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.statisticRoutes, (Route<dynamic> route) => false);
    });
  }

  showErrorMessage(String message){
    Future.delayed(const Duration(milliseconds: 500), () {
      if(!isErrorMessageAppeared){
        MessageWidget.showSnackBar(message, AppColors.redAlertColor);
        setState(() {
          isErrorMessageAppeared = true;
        });
      }
    });
  }

  initialErrorStatus(){
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isErrorMessageAppeared = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<LoginCubit , LoginState>(builder: (context , state){
      return Scaffold(
       bottomNavigationBar: const LogoWidget(),
        appBar: AppBar(
          title: Text('login'.tr),
          leading: IconButton(
            onPressed: (){
              if(widget.addOtherMail){
                Navigator.of(context).pop();
              } else {
                exit(0);
              }
            },
            icon: const Icon(Icons.arrow_back_sharp),
            color: AppColors.whiteColor,
          ),
        ),
        body: checkState(state)
      );
    });
  }
}
