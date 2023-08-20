import 'package:claimizer/config/arguments/routes_arguments.dart';
import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/login/presentation/screen/login_screen.dart';
import 'package:claimizer/feature/statistics/data/models/statistic_model.dart';
import 'package:claimizer/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:claimizer/feature/statistics/presentation/widget/statistic_widget.dart';
import 'package:claimizer/widgets/alert_dilog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {

  TextEditingController searchController = TextEditingController();
  List<StatisticSummary> statisticList = [];
  List<StatisticSummary> statisticListData = [];
  bool isInitialized = false , isSearching = false;
  TextStyle searchTextStyle = TextStyle(color: AppColors.whiteColor , fontSize: 16.sp);


  getData() =>BlocProvider.of<StatisticCubit>(context).getData();

  @override
  void initState() {
    super.initState();
    getData();
  }

  callLogoutDialog(){
    Future.delayed(const Duration(milliseconds: 500), () {
      AlertDialogWidget dialogWidget = AlertDialogWidget(title: 'logOutPhase'.tr, yesOnTap: (){
        deleteUserData();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>const LoginScreen()), (Route<dynamic> route) => false);
      }, context: context);
      dialogWidget.logOutDialog();
    });
  }


  void filterSearchResults(String name) {
    if(name.isEmpty){
      setState(() {
        statisticList = statisticListData;
      });
    }
    setState(() {
      statisticList = statisticListData
          .where((element) => element.companyName.toLowerCase().contains(name.toLowerCase()) || element.buildingName.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
  }

  deleteUserData() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(AppStrings.token);
    preferences.remove(AppStrings.userName);
  }

  Widget _statisticWidget(){
    return BlocBuilder<StatisticCubit, StatisticState>(
        builder: ((context, state) {
          if (state is StatisticsIsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StatisticsError) {
            return ErrorWidget(()=>getData());
          } else if (state is StatisticsLoaded) {
            if (!isInitialized) {
              statisticList = state.statistic.statisticData;
              statisticListData = state.statistic.statisticData;
              isInitialized = true;
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(physics:const NeverScrollableScrollPhysics() , shrinkWrap: true ,  itemCount:statisticList.length , itemBuilder: (ctx , pos){
                    return InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, Routes.statisticDetailsRoutes , arguments: StatisticDetailsRoutesArguments(uniqueId: statisticList[pos].uniqueValue));
                        setState(() {
                          statisticList = statisticListData;
                        });
                      },
                      child: StatisticWidgetItem(companyName: statisticList[pos].companyName ,buildingName: statisticList[pos].buildingName,date: Helper.convertStringToDateOnly(statisticList[pos].statisticsDate.toString()),),
                    );
                  })
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }

  changeSearchingState(){
    setState(() {
      isSearching = false;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Scaffold(
          appBar: isSearching ?
          PreferredSize(preferredSize: const Size.fromHeight(100),
            child: Container(
              //margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              color: AppColors.primaryColor,
              child: Padding(padding: EdgeInsets.all(10.sp) , child: TextField(
                style: searchTextStyle,
                cursorColor: AppColors.whiteColor,
                onChanged: (value){
                  setState(() {
                    filterSearchResults(value);
                  });
                },
                onTapOutside: (_)=>changeSearchingState(),
                onSubmitted: (_)=>changeSearchingState(),
                onEditingComplete: ()=>changeSearchingState(),
                controller: searchController,
                decoration: InputDecoration(
                    //labelText: "search".tr,
                    hintText: "Search".tr,
                    hintStyle: searchTextStyle,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: ScreenUtil().setHeight(30))

                ),
              ))),

            ) :
          AppBar(
              title: Text('companies'.tr),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    callLogoutDialog();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]
          ),
          body: _statisticWidget(),
        ),
        onRefresh: () => getData());
  }
}
