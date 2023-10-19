import 'dart:async';
import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/assets_manager.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/login/presentation/cubit/login_cubit.dart';
import 'package:claimizer/widgets/button_widget.dart';
import 'package:claimizer/widgets/message_widget.dart';
import 'package:claimizer/widgets/text_widget.dart';
import 'package:claimizer/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {

  bool addOtherMail;
  LoginScreen({super.key , required this.addOtherMail});

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
        Image.asset(AssetsManager.logoIcon, width: ScreenUtil().setWidth(93),height: ScreenUtil().setHeight(95),),
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
                context.read<LoginCubit>().login(emailController.value.text.toString(), passwordController.value.text.toString());
              },
              name: 'login'.tr
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().initLoginPage();
  }
  Widget checkState(LoginState state){
     if(state is LoginIsLoading){
       initialErrorStatus();
      return const Center(child: CircularProgressIndicator(),);
    } else if(state is LoginError){
      showErrorMessage(state.msg);
      return _loginWidget();
    } else if(state is LoginLoaded) {
      goToNextScreen();
      return const SizedBox();
    } else {
      return _loginWidget();
    }
  }

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
        body: checkState(state)
      );
    });
  }
}
