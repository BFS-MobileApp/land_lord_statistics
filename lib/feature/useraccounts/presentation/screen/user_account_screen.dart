import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/feature/useraccounts/presentation/cubit/user_accounts_cubit.dart';
import 'package:claimizer/feature/useraccounts/presentation/widget/user_accounts_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(30)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('userAccounts'.tr , style: const TextStyle(color: Colors.blue , ),),
                    Icon(Icons.add , size:  25.sp, color: Colors.blue,)
                  ],
                ),
                userAccountsWidgets()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
