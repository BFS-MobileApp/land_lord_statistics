import 'package:LandlordStatistics/config/PrefHelper/dbhelper.dart';
import 'package:LandlordStatistics/config/PrefHelper/prefs.dart';
import 'package:LandlordStatistics/config/arguments/routes_arguments.dart';
import 'package:LandlordStatistics/config/routes/app_routes.dart';
import 'package:LandlordStatistics/core/api/end_points.dart';
import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/app_strings.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/feature/setting/presentation/cubit/setting_cubit.dart';
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

  String dropDownValue = '' , name = '';
  final databaseHelper = DatabaseHelper.instance;
  bool isUsingMultiServerFeature = false;
  String urlType = '';


  getAccounts() =>BlocProvider.of<SettingCubit>(context).getData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccounts();
    getCurrentLocal();
    getActiveUserName();
    checkMultiServerFeature();
  }

  getActiveUserName() async{
    await databaseHelper.getActiveUserName().then((value){
      setState(() {
        name = value;
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
            return ListView.builder(shrinkWrap: true, physics: const ClampingScrollPhysics(),itemCount: state.userAccounts.length , itemBuilder: (ctx , pos){
              return UserAccountItem(ctx: context,email: state.userAccounts[pos].email, isActive: state.userAccounts[pos].active);
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
        title: Text('userAccounts'.tr),
      ),
      body: ListView(
        children: [
          isUsingMultiServerFeature ? Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
            child: Center(
              child: Text(urlType , style: TextStyle(fontWeight: FontWeight.w700 , color: AppColors.primaryColor , fontSize: 16.sp),),
            ),
          ) : const SizedBox(),
          Card(
            elevation: 3,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height/2),
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10) , right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(30)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('userAccounts'.tr , style: const TextStyle(color: Colors.blue , ),),
                      IconButton(
                        onPressed: ()=>Navigator.pushNamed(context, Routes.loginRoutes , arguments: LoginRoutesArguments(addOtherMail: true , isThereExistingUsers: true)),
                        icon: const Icon(Icons.add),
                        iconSize: 25.sp,
                        color: Colors.blue,
                      )
                    ],
                  ),
                  userAccountsWidgets()
                ],
              ),
            ),
          ),
          Card(
            elevation: 3,
            child: Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10) , right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(30)),
              child: InkWell(
                onTap: ()=>callLogoutDialog(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('changeLanguage'.tr , style: TextStyle(fontSize: 18.sp , color: Colors.blueAccent),),
                    DropdownButton<String>(
                      value: dropDownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          changeLocalization();
                        });
                      },
                      items: [
                        buildDropdownItem('English', CountryFlag.fromLanguageCode('en')),
                        buildDropdownItem('العربية', CountryFlag.fromCountryCode('ae')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 3,
            child: Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10) , right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(30)),
              child: InkWell(
                onTap: ()=>callLogoutDialog(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('logout'.tr , style: TextStyle(fontSize: 18.sp , color: Colors.red),),
                    const Icon(Icons.logout)
                  ],
                ),
              ),
            ),
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
