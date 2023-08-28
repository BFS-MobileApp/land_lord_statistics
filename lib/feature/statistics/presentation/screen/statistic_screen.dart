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
  FocusNode focusNode = FocusNode();
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
      statisticList = statisticList
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
            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ReorderableListView.builder(
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final element = statisticList.removeAt(oldIndex);
                        statisticList.insert(newIndex, element);
                        BlocProvider.of<StatisticCubit>(context).setSettings('#FF0000', 3, 'BFS-1-C');
                      });
                    }, itemBuilder: (BuildContext context, int pos) {
                    return InkWell(
                      key: ValueKey(statisticList[pos]),
                      onTap: (){
                        Navigator.pushNamed(context, Routes.statisticDetailsRoutes , arguments: StatisticDetailsRoutesArguments(uniqueId: statisticList[pos].uniqueValue , companyName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].companyNameAr :statisticList[pos].companyName , buildingName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].buildingNameA : statisticList[pos].buildingName , date: Helper.convertStringToDateOnly(statisticList[pos].statisticsDate.toString())));
                        setState(() {
                          statisticList = statisticListData;
                        });
                      },
                      child: StatisticWidgetItem(pos: pos , statisticList: statisticList , color:  statisticList[pos].color , id: statisticList[pos].statisticsId , companyName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].companyNameAr : statisticList[pos].companyName ,buildingName: Helper.getCurrentLocal() == '' ? statisticList[pos].buildingNameA : statisticList[pos].buildingName,date: Helper.convertStringToDateOnly(statisticList[pos].statisticsDate.toString()),),
                    );
                  }, itemCount: statisticList.length,),
                )
              ],
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
      statisticList = statisticListData;
      searchController.clear();
    });
  }

  changeLocalization(){
    final currentLocal = Get.locale;
    //print('main'+currentLocal!.countryCode.toString());
    if (currentLocal!.countryCode == 'AR') {
      var locale = const Locale('en', 'US');
      Get.updateLocale(locale);
      Helper.setDefaultLang(AppStrings.enCountryCode);
    } else {
      var locale = const Locale('ar', 'AR');
      Get.updateLocale(locale);
      Helper.setDefaultLang(AppStrings.arCountryCode);
    }
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
                showCursor: true,
                focusNode: focusNode,
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
                    hintText: "search".tr,
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
                      focusNode.requestFocus();
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
              ],
              leading: IconButton(
                onPressed: changeLocalization,
                icon: const Icon(Icons.translate_outlined ),
                color: AppColors.whiteColor,
                iconSize: 20.sp,
              ),
          ),
          body: _statisticWidget(),
        ),
        onRefresh: () => getData());
  }
}
