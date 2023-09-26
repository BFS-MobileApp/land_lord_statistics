import 'package:claimizer/config/PrefHelper/dbhelper.dart';
import 'package:claimizer/config/arguments/routes_arguments.dart';
import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/feature/useraccounts/presentation/cubit/user_accounts_cubit.dart';
import 'package:claimizer/feature/useraccounts/presentation/widget/user_accounts_item.dart';
import 'package:claimizer/widgets/alert_dilog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountsScreen extends StatefulWidget {
  const UserAccountsScreen({super.key});

  @override
  State<UserAccountsScreen> createState() => _UserAccountsScreenState();
}

class _UserAccountsScreenState extends State<UserAccountsScreen> {

  getAccounts() =>BlocProvider.of<UserAccountsCubit>(context).getData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccounts();
  }

  callLogoutDialog(){
    Future.delayed(const Duration(milliseconds: 500), () {
      AlertDialogWidget dialogWidget = AlertDialogWidget(title: 'logOutPhase'.tr, yesOnTap: (){
        deleteUserData();
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginRoutes,arguments: LoginRoutesArguments(addOtherMail: false), (Route<dynamic> route) => false);
      }, context: context);
      dialogWidget.logOutDialog();
    });
  }

  goToNextScreen(){
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.statisticRoutes, (Route<dynamic> route) => false);
    });
  }

  deleteUserData() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final databaseHelper = DatabaseHelper.instance;
    databaseHelper.deleteAllActiveUsers();
    preferences.remove(AppStrings.token);
    preferences.remove(AppStrings.userName);
  }


  Widget userAccountsWidgets(){
    return BlocBuilder<UserAccountsCubit, UserAccountsState>(
        builder: ((context, state) {
          if (state is UserAccountsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserAccountsError) {
            return ErrorWidget((){});
          } else if (state is UserAccountsLoaded) {
            return ListView.builder(shrinkWrap: true, physics: const ClampingScrollPhysics(),itemCount: state.userAccounts.length , itemBuilder: (ctx , pos){
              return UserAccountItem(email: state.userAccounts[pos].email, isActive: state.userAccounts[pos].active);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('userAccounts'.tr),
      ),
      body: ListView(
        children: [
          Card(
            elevation: 3,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.height/2),
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(30)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('userAccounts'.tr , style: const TextStyle(color: Colors.blue , ),),
                      IconButton(
                        onPressed: ()=>Navigator.pushReplacementNamed(context, Routes.loginRoutes , arguments: LoginRoutesArguments(addOtherMail: true)),
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
                    Text('logout'.tr , style: TextStyle(fontSize: 18.sp , color: Colors.red),),
                    const Icon(Icons.logout)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
