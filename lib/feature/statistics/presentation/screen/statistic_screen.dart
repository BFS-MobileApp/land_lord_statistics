import 'dart:io';

import 'package:claimizer/config/arguments/routes_arguments.dart';
import 'package:claimizer/config/routes/app_routes.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/statistics/data/models/statistic_model.dart';
import 'package:claimizer/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:claimizer/feature/statistics/presentation/widget/statistic_widget.dart';
import 'package:claimizer/widgets/aligment_widget.dart';
import 'package:claimizer/widgets/empty_data_widget.dart';
import 'package:claimizer/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {

  TextEditingController searchController = TextEditingController();
  List<StatisticSummary> statisticList = [];
  List<StatisticSummary> statisticListData = [];
  List<StatisticSummary> updatedStatisticListData = [];
  FocusNode focusNode = FocusNode();
  bool isInitialized = false , isSearching = false;
  TextStyle searchTextStyle = TextStyle(color: AppColors.whiteColor , fontSize: 16.sp);
  AlignmentWidget alignmentWidget = AlignmentWidget();
  Map<String, bool> isMenuOpenMap = {};


  getData() =>BlocProvider.of<StatisticCubit>(context).getData();

  @override 
  void initState() {
    super.initState();
    getData();
  }

  /*Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    print(info.version);
    print(info.packageName);
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  /*callUpdateDialog() async{
    Future.delayed(const Duration(milliseconds: 500), () {
      ForceUpdateDialogWidget dialogWidget = ForceUpdateDialogWidget(context: context);
      dialogWidget.updateDialog();
    });
  }*/

  dynamic findMaxSortValue() {
    dynamic maxSortValue = double.negativeInfinity;
    for (var data in statisticList) {
        double sortValue = double.tryParse(data.sortValue.toString()) ?? 0.0;
        if (sortValue > maxSortValue) {
          maxSortValue = sortValue;
        }
    }
    return maxSortValue;
  }

  double findMinSortValue() {
    double minSortValue = double.infinity;
    for (var data in statisticList) {
        double sortValue = double.tryParse(data.sortValue.toString()) ?? 0.0;
        if (sortValue < minSortValue) {
          minSortValue = sortValue;
        }
    }
    return minSortValue;
  }

  void filterSearchResults(String name) {
    setState(() {
      updatedStatisticListData.clear();
    });
    if(name.isEmpty){
      setState(() {
        statisticList = statisticListData;
      });
    }
    if(Helper.getCurrentLocal() == 'AR'){
      setState(() {
        statisticList = statisticListData
            .where((element) => element.companyNameAr.toLowerCase().contains(name.toLowerCase()) || element.buildingNameA.toLowerCase().contains(name.toLowerCase()))
            .toList();
        updatedStatisticListData = statisticList;
      });
    } else {
      setState(() {
        statisticList = statisticListData
            .where((element) => element.companyName.toLowerCase().contains(name.toLowerCase()) || element.buildingName.toLowerCase().contains(name.toLowerCase()))
            .toList();
        updatedStatisticListData = statisticList;
      });
    }
  }

  clearData(){
    setState(() {
      isInitialized = false;
      statisticList.clear();
      statisticListData.clear();
      updatedStatisticListData.clear();
    });
  }

  Widget _statisticWidget(){
    return BlocBuilder<StatisticCubit, StatisticState>(
        builder: ((context, state) {
          if (state is StatisticsIsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StatisticsError) {
            return ErrorWidgetItem(onTap: (){getData();},);
            return const EmptyDataWidget();
          } else if (state is StatisticsLoaded) {
            if(state.statistic.statisticData.isEmpty){
              return const EmptyDataWidget();
            }
            if (!isInitialized) {
              statisticList = state.statistic.statisticData;
              statisticListData = state.statistic.statisticData;
              isInitialized = true;
              statisticList.sort((a, b) => a.sortValue.compareTo(b.sortValue));
              statisticListData.sort((a, b) => a.sortValue.compareTo(b.sortValue));
            }
            return ListView(
              children: [
                ListView.builder(physics:const ClampingScrollPhysics() , shrinkWrap: true ,  itemCount:statisticList.length , itemBuilder: (ctx , pos){
                  isMenuOpenMap.putIfAbsent(state.statistic.statisticData[pos].uniqueValue, () => false);
                  return InkWell(
                    onTap: (){
                      if(updatedStatisticListData.isEmpty){
                        Navigator.pushNamed(context, Routes.statisticDetailsRoutes , arguments: StatisticDetailsRoutesArguments(uniqueId: statisticList[pos].uniqueValue , companyName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].companyNameAr :statisticList[pos].companyName , buildingName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].buildingNameA : statisticList[pos].buildingName , date: Helper.convertStringToDateOnly(statisticList[pos].statisticsDate.toString())));
                        updatedStatisticListData.clear();
                        print('cleared');

                      } else {
                        Navigator.pushNamed(context, Routes.statisticDetailsRoutes , arguments: StatisticDetailsRoutesArguments(uniqueId: updatedStatisticListData[pos].uniqueValue , companyName: Helper.getCurrentLocal() == 'AR' ? updatedStatisticListData[pos].companyNameAr :updatedStatisticListData[pos].companyName , buildingName: Helper.getCurrentLocal() == 'AR' ? updatedStatisticListData[pos].buildingNameA : updatedStatisticListData[pos].buildingName , date: Helper.convertStringToDateOnly(updatedStatisticListData[pos].statisticsDate.toString())));
                        updatedStatisticListData.clear();
                        print('cleared');
                      }
                    },
                    child: StatisticWidgetItem(isMenuOpenMap: isMenuOpenMap,maxSort: findMaxSortValue() , minSort: findMinSortValue() , pos: pos , statisticList: statisticList , color:  statisticList[pos].colorValue , uniqueId: statisticList[pos].uniqueValue , companyName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].companyNameAr : statisticList[pos].companyName ,buildingName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].buildingNameA : statisticList[pos].buildingName,date: Helper.convertStringToDateOnly(statisticList[pos].statisticsDate.toString()),),
                  );
                }),
                Container(
                  alignment: alignmentWidget.returnAlignment(),
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10) , vertical: ScreenUtil().setHeight(5)),
                  child: Row(
                    children: [
                      Text('${'count'.tr}: ' ,style: const TextStyle(fontWeight: FontWeight.w500),),
                      Text(statisticList.length.toString(),style: const TextStyle(fontWeight: FontWeight.w500),)
                    ],
                  ),
                )
              ],
            );
          } else if(state is StatisticsRefresh){
            return ListView(
              children: [
                ListView.builder(physics:const ClampingScrollPhysics() , shrinkWrap: true ,  itemCount:state.statisticList.length , itemBuilder: (ctx , pos){
                  //isMenuOpenMap.putIfAbsent(state.statisticList[pos].uniqueValue, () => false);
                  return InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, Routes.statisticDetailsRoutes , arguments: StatisticDetailsRoutesArguments(uniqueId: statisticList[pos].uniqueValue , companyName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].companyNameAr :statisticList[pos].companyName , buildingName: Helper.getCurrentLocal() == 'AR' ? statisticList[pos].buildingNameA : statisticList[pos].buildingName , date: Helper.convertStringToDateOnly(statisticList[pos].statisticsDate.toString())));
                      /*setState(() {
                    statisticList = statisticListData;
                  });*/
                    },
                    child: StatisticWidgetItem(isMenuOpenMap: isMenuOpenMap,maxSort: findMaxSortValue() , minSort: findMinSortValue() ,pos: pos , statisticList: state.statisticList , color:  state.statisticList[pos].colorValue , uniqueId: state.statisticList[pos].uniqueValue , companyName: Helper.getCurrentLocal() == 'AR' ? state.statisticList[pos].companyNameAr : state.statisticList[pos].companyName ,buildingName: Helper.getCurrentLocal() == 'AR' ? state.statisticList[pos].buildingNameA : state.statisticList[pos].buildingName,date: Helper.convertStringToDateOnly(state.statisticList[pos].statisticsDate.toString()),),
                  );
                }),
                Container(
                  alignment: alignmentWidget.returnAlignment(),
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10) , vertical: ScreenUtil().setHeight(5)),
                  child: Row(
                    children: [
                      Text('${'count'.tr}: ' ,style: const TextStyle(fontWeight: FontWeight.w500),),
                      Text(statisticList.length.toString(),style: const TextStyle(fontWeight: FontWeight.w500),)
                    ],
                  ),
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
      //updatedStatisticListData.clear();
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
              child: Padding(padding: EdgeInsets.only(top: ScreenUtil().setHeight(10) , bottom: ScreenUtil().setHeight(5) , left: ScreenUtil().setWidth(10) , right: ScreenUtil().setWidth(10)) , child: TextField(
                style: searchTextStyle,
                cursorColor: AppColors.whiteColor,
                showCursor: true,
                focusNode: focusNode,
                onChanged: (value){
                  setState(() {
                    if (value.isEmpty) {
                      statisticList = statisticListData; // Reset to original list when search is empty
                    } else {
                      filterSearchResults(value); // Apply the filter for non-empty search
                    }
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
                    suffixIcon: Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
                      child: IconButton(
                        onPressed: (){
                          /*setState(() {
                            statisticList = statisticListData;
                            searchController.clear();
                          });*/
                          changeSearchingState();
                        },
                        icon: const Icon(Icons.clear , color: Colors.white,),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: ScreenUtil().setHeight(45))
                ),
              ))),
            ) :
          AppBar(
              title: Text('landlordStatistics'.tr),
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
                    Navigator.pushNamed(context, Routes.userAccountsRoutes);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
              leading: IconButton(
                onPressed: ()=>exit(0),
                icon: const Icon(Icons.arrow_back_sharp),
                color: AppColors.whiteColor,
              ),
          ),
          body: _statisticWidget(),
        ),
        onRefresh: () async{
          await clearData();
          await getData();
        });
  }
}
