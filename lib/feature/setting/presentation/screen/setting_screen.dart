import 'package:LandlordStatistics/config/PrefHelper/dbhelper.dart';
import 'package:LandlordStatistics/config/PrefHelper/prefs.dart';
import 'package:LandlordStatistics/config/arguments/routes_arguments.dart';
import 'package:LandlordStatistics/config/routes/app_routes.dart';
import 'package:LandlordStatistics/core/api/end_points.dart';
import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/app_strings.dart';
import 'package:LandlordStatistics/core/utils/assets_manager.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/feature/setting/presentation/cubit/setting_cubit.dart';
import 'package:LandlordStatistics/feature/setting/presentation/widget/add_account_widget.dart';
import 'package:LandlordStatistics/feature/setting/presentation/widget/container_item.dart';
import 'package:LandlordStatistics/feature/setting/presentation/widget/user_accounts_item.dart';
import 'package:LandlordStatistics/widgets/alert_dilog_widget.dart';
import 'package:LandlordStatistics/widgets/logo_widget.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  String dropDownValue = '' , name = '' , mail = '';
  final databaseHelper = DatabaseHelper.instance;
  bool isUsingMultiServerFeature = false;
  String urlType = '';
  bool _isExpanded = false;

  getAccounts() =>BlocProvider.of<SettingCubit>(context).getData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccounts();
    getCurrentLocal();
    getActiveUserName();
    getActiveMail();
    checkMultiServerFeature();
  }

  getActiveUserName() async{
    await databaseHelper.getActiveUserName().then((value){
      setState(() {
        name = value;
      });
    });
  }

  getActiveMail() async{
    await databaseHelper.getActiveMail().then((value){
      setState(() {
        mail = value;
      });
    });
  }

  callLogoutDialog() async{
    bool result = await checkIfThereIsExistingUsers();
    Future.delayed(const Duration(milliseconds: 500), () {
      AlertDialogWidget dialogWidget = AlertDialogWidget(title: 'logOutPhase'.tr, yesOnTap: (){
        deleteUserData();
        if(result == false){
          databaseHelper.deleteAllSavedUrls();
        }
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginRoutes,arguments: LoginRoutesArguments(addOtherMail: false , isThereExistingUsers: result), (Route<dynamic> route) => false);
      }, context: context);
      dialogWidget.logOutDialog();
    });
  }

  Future<bool> checkIfThereIsExistingUsers() async{
    final databaseHelper = DatabaseHelper.instance;
    int userNumbers = await databaseHelper.getUsersNums();
    if(userNumbers>1){
      return true;
    }
    return false;

  }

  goToNextScreen(){
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.statisticRoutes, (Route<dynamic> route) => false);
    });
  }

  deleteUserData() async{
    databaseHelper.deleteAllActiveUsers();
    Prefs.clear();
  }

  Widget userAccountsWidgets(){
    return BlocBuilder<SettingCubit, SettingState>(
        builder: ((context, state) {
          if (state is UserAccountsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserAccountsError) {
            return ErrorWidget((){});
          } else if (state is UserAccountsLoaded) {
            return ListView.builder(shrinkWrap: true, physics: const ClampingScrollPhysics(),itemCount: state.userAccounts.length+1 , itemBuilder: (ctx , pos){
              return pos <state.userAccounts.length ? UserAccountItem(ctx: context,email: state.userAccounts[pos].email, isActive: state.userAccounts[pos].active) : AddAccountWidget();
            });
          } else if(state is UserAccountChanged){
            goToNextScreen();
            return const SizedBox();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }

  changeLocalization(){
    final currentLocal = Get.locale;
    if (currentLocal!.countryCode == 'AR') {
      var locale = const Locale('en', 'US');
      Get.updateLocale(locale);
      Helper.setDefaultLang(AppStrings.enCountryCode);
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.statisticRoutes, (Route<dynamic> route) => false);
    } else {
      var locale = const Locale('ar', 'AR');
      Get.updateLocale(locale);
      Helper.setDefaultLang(AppStrings.arCountryCode);
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.statisticRoutes, (Route<dynamic> route) => false);
    }
  }

  getCurrentLocal(){
    if(Helper.getCurrentLocal() == 'AR'){
      setState(() {
        dropDownValue = 'العربية';
      });
    } else {

      dropDownValue = 'English';
    }
  }

  checkMultiServerFeature() async{
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    bool result = await databaseHelper.hasDataInUrlTable();
    if(result){
      setState(() {
        isUsingMultiServerFeature = true;
      });
      String url = await databaseHelper.getSavedUrl();
      if(url == EndPoints.betaUrl){
        setState(() {
          urlType = 'Beta Version';
        });
        return;
      }
      setState(() {
        urlType = 'Live Version';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const LogoWidget(),
      appBar: AppBar(
        title: Text(mail),
        leading: InkWell(
          child: Image.asset(AssetsManager.back , width: ScreenUtil().setWidth(14),height: ScreenUtil().setHeight(8),),
          onTap: (){
            Navigator.of(context).pop();
          },

        ),
      ),
      body: ListView(
        children: [
          isUsingMultiServerFeature ? Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
            child: Center(
              child: Text(urlType , style: TextStyle(fontWeight: FontWeight.w700 , color: AppColors.primaryColor , fontSize: 16.sp),),
            ),
          ) : const SizedBox(),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
            width: ScreenUtil().setWidth(66),
            height: ScreenUtil().setHeight(66),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.loginPhaseFontColor),
            child: Center(
              child: Text(Helper.returnFirstTwoChars(name) , style: TextStyle(fontWeight: FontWeight.w700 , fontSize: 20.sp , color: AppColors.whiteColor),),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10) , top: ScreenUtil().setHeight(10)),
            alignment: Alignment.center,
            child: Text('${'hi'.tr}, $name' , style: TextStyle(fontSize: 14.sp , fontWeight: FontWeight.w700 , color: AppColors.black),),
          ),
          ContainerItem(
              itemWidget: ExpansionTile(
                tilePadding: Helper.getCurrentLocal() =='AR' ? EdgeInsets.only(left: ScreenUtil().setWidth(60)) : EdgeInsets.only(right: ScreenUtil().setWidth(60)),
                onExpansionChanged: (expanded){
                  setState(() {
                    _isExpanded = expanded;
                  });
                },
                title: Row(
                  children: [
                    Icon(Icons.person , size: 24.sp , color: AppColors.black,),
                    SizedBox(width: ScreenUtil().setWidth(5),),
                    Text('manageAccounts'.tr , style: TextStyle(fontSize: 16.sp , fontWeight: FontWeight.w700 , color: AppColors.black),)
                  ],
                ),
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: _isExpanded ? null : 0,
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return constraints.isTight
                            ? const SizedBox.shrink()
                            : userAccountsWidgets();
                      },
                    ),
                  ),
                ],
              ),
          ),
          ContainerItem(
            itemWidget: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.language , size: 24.sp,color: AppColors.black,),
                    SizedBox(width: ScreenUtil().setWidth(5),),
                    Text('language'.tr , style: TextStyle(fontSize: 14.sp , fontWeight: FontWeight.w600),)
                  ],
                ),
                DropdownButton<String>(
                  value: dropDownValue,
                  elevation: 0,
                  onChanged: (String? newValue) {
                    setState(() {
                      changeLocalization();
                    });
                  },
                  items: [
                    buildDropdownItem('English', CountryFlag.fromLanguageCode('en')),
                    buildDropdownItem('العربية', CountryFlag.fromCountryCode('ae')),
                  ],
                )
              ],
            ),
            height: 50,),
          InkWell(
            onTap: callLogoutDialog,
            child: ContainerItem(
              itemWidget: Row(
                children: [
                  Icon(Icons.logout , size: 24.sp,color: AppColors.red,),
                  SizedBox(width: ScreenUtil().setWidth(5),),
                  Text('logout'.tr , style: TextStyle(fontSize: 14.sp , fontWeight: FontWeight.w600),)
                ],
              ),
              height: 50,),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildDropdownItem(String language, Widget flag) {
    return DropdownMenuItem<String>(
      value: language,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setHeight(20),
                child: flag,
              ),
              SizedBox(width: ScreenUtil().setWidth(10.0)),
              Text(language , style: const TextStyle(fontWeight: FontWeight.w600),),
            ],
          ),
        ],
      ),
    );
  }
}
