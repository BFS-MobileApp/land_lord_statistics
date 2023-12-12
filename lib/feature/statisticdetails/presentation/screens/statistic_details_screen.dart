// ignore_for_file: must_be_immutable

import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/assets_manager.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/chart_widget.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/statistic_detailes_item.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/text_item.dart';
import 'package:LandlordStatistics/widgets/aligment_widget.dart';
import 'package:LandlordStatistics/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class StatisticDetailsScreen extends StatefulWidget {

  final String uniqueId;
  final String companyName;
  final String buildingName;
  String date;

  StatisticDetailsScreen({super.key , required this.uniqueId , required this.companyName , required this.buildingName , required this.date});

  @override
  State<StatisticDetailsScreen> createState() => _StatisticDetailsScreenState();
}

class _StatisticDetailsScreenState extends State<StatisticDetailsScreen> {

  List<StatisticColoumn> statisticListData = [];
  List<StatisticColoumn> statisticListDataDetails = [];
  bool isInitialized = false , isSearching = false;
  FocusNode focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  TextStyle searchTextStyle = TextStyle(color: AppColors.whiteColor , fontSize: 16.sp);
  int selectedOption = 0;
  Map<String, bool> isMenuOpenMap = {};
  AlignmentWidget alignmentWidget = AlignmentWidget();

  getData() =>BlocProvider.of<StatisticDetailsCubit>(context).getData(widget.uniqueId);

  void filterSearchResults(String name) {
    if(name.isEmpty){
      setState(() {
        statisticListData = statisticListDataDetails;
      });
    }
    if(Helper.getCurrentLocal() == 'AR'){
      setState(() {
        statisticListData = statisticListData
            .where((element) => element.arName.toLowerCase().contains(name.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        statisticListData = statisticListData
            .where((element) => element.enName.toLowerCase().contains(name.toLowerCase()))
            .toList();
      });
    }
  }

  changeSearchingState(){
    setState(() {
      isSearching = false;
      statisticListData = statisticListDataDetails;
      searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void sortDialog(){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context , StateSetter setState){
                return AlertDialog(
                  content: SizedBox(
                    height: ScreenUtil().setHeight(111),
                    child: Column(
                      children: <Widget>[
                        Text('sortBy'.tr, style: TextStyle(fontWeight: FontWeight.w700 , fontSize: 15.sp),),
                        ListTile(
                          title: Text('name'.tr),
                          leading: Radio<int>(
                            value: 1,
                            groupValue: selectedOption,
                            onChanged: (int? value) {
                              setState(() {
                                selectedOption = value!;
                                Navigator.of(context).pop(true);
                                sortList();
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text('value'.tr),
                          leading: Radio<int>(
                            value: 2,
                            groupValue: selectedOption,
                            onChanged: (int? value) {
                              setState(() {
                                selectedOption = value!;
                                Navigator.of(context).pop(true);
                                sortList();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        });
  }

  sortList(){
    switch (selectedOption){
      case 1:
        setState(() {
          if(Helper.getCurrentLocal()== 'AR'){
            statisticListData.sort((a, b) => a.arName.compareTo(b.arName));
          } else {
            statisticListData.sort((a, b) => a.enName.compareTo(b.enName));
          }
          selectedOption = 0;
        });
        break;
      case 2:
        setState(() {
          statisticListData.sort((a, b) => a.value.compareTo(b.value));
          selectedOption = 0;
        });
        break;
    }
  }

  clearData(){
    setState(() {
      statisticListData.clear();
      statisticListDataDetails.clear();
      isInitialized = false;
    });
  }

  Widget _statisticWidget(){
    return BlocBuilder<StatisticDetailsCubit, StatisticDetailsState>(
        builder: ((context, state) {
          if (state is StatisticsDetailsIsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StatisticsDetailsError) {
            return ErrorWidgetItem(onTap: getData,);
          } else if (state is StatisticsDetailsLoaded) {
            if(state.data.statisticColoumns.isEmpty){
              return Center(
                child: Text('noData'.tr , style: TextStyle(fontSize: 20.sp , color: AppColors.grey , fontWeight: FontWeight.w600),),
              );
            }
            if (!isInitialized) {
              statisticListData = state.data.statisticColoumns;
              statisticListData.sort((a, b) => a.userSort.compareTo(b.userSort));
              statisticListData.removeWhere((element) => element.value =='');
              statisticListDataDetails = statisticListData;
              isInitialized = true;
            }
            return Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(20) , bottom: ScreenUtil().setHeight(50)),
              child: Column(
                children: [
                  Container(
                    alignment: alignmentWidget.returnAlignment(),
                    margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
                    child: Text(widget.companyName , style: TextStyle(fontWeight: FontWeight.w700 , color: AppColors.black , fontSize: 17.sp),),
                  ),
                  widget.buildingName == '' ? const SizedBox() : TextItem(image: AssetsManager.building , itemName: '${'buildingName'.tr}: ', itemValue: widget.buildingName),
                  TextItem(itemName: '${'statisticDate'.tr}: ', itemValue: widget.date , image: AssetsManager.date2),
                  SizedBox(height: ScreenUtil().setHeight(8),),
                  Expanded(child: ListView(
                    children: [
                      GridView.count(
                        crossAxisCount: 1,
                        padding: EdgeInsets.zero,
                        childAspectRatio: 4,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        children: List.generate(statisticListData.length, (pos)
                        {
                          isMenuOpenMap.putIfAbsent(statisticListData[pos].columnName, () => false);
                          return StatisticDetailsItem(isMenuOpenMap: isMenuOpenMap,data: state.data , sort: statisticListData[pos].sort , columnName: statisticListData[pos].columnName , icon: statisticListData[pos].iconSvg , statisticListData: statisticListData , pos: pos , uniqueId: widget.uniqueId , id: statisticListData[pos].id, userColor: statisticListData[pos].userColor == '' ? statisticListData[pos].color : statisticListData[pos].userColor ,itemName: Helper.getCurrentLocal() == 'AR' ? statisticListData[pos].arName : statisticListData[pos].enName,itemValue: statisticListData[pos].value,);
                        }),
                      ),
                      state.data.charts.isEmpty? const SizedBox() :  ListView.builder(shrinkWrap: true, physics: const ClampingScrollPhysics(),itemCount:state.data.charts.length  , itemBuilder: (ctx , pos){
                        return ChartWidget(englishName: state.data.charts[pos].chartSetting.enName, araibicName: state.data.charts[pos].chartSetting.arName, chartsColors: state.data.charts[pos].finalApiData.color , precent: state.data.charts[pos].finalApiData.percent , chartData: state.data.charts[pos].chartData);
                      })
                    ],
                  ))
                ],
              ),
            );
          } else if(state is StatisticsDetailsRefresh){
            return Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(20) , bottom: ScreenUtil().setHeight(50)),
              child: Column(
                children: [
                  Container(
                    alignment: alignmentWidget.returnAlignment(),
                    margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
                    child: Text(widget.companyName , style: TextStyle(fontWeight: FontWeight.w700 , color: AppColors.black , fontSize: 17.sp),),
                  ),
                  widget.buildingName == '' ? const SizedBox() : TextItem(image: AssetsManager.building , itemName: '${'buildingName'.tr}: ', itemValue: widget.buildingName),
                  TextItem(itemName: '${'statisticDate'.tr}: ', itemValue: widget.date , image: AssetsManager.date2),
                  SizedBox(height: ScreenUtil().setHeight(8),),
                  Expanded(child: ListView(
                    children: [
                      GridView.count(
                        crossAxisCount: 1,
                        padding: EdgeInsets.zero,
                        childAspectRatio: 4,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        children: List.generate(statisticListData.length, (pos)
                        {
                          //isMenuOpenMap.clear();
                          isMenuOpenMap.putIfAbsent(statisticListData[pos].columnName, () => false);
                          return StatisticDetailsItem(isMenuOpenMap: isMenuOpenMap,data: state.data , sort: state.statisticList[pos].sort , columnName: state.statisticList[pos].columnName , icon: state.statisticList[pos].iconSvg , statisticListData: state.statisticList , pos: pos , uniqueId: widget.uniqueId , id: state.statisticList[pos].id, userColor: state.statisticList[pos].userColor == '' ? state.statisticList[pos].color : state.statisticList[pos].userColor , itemName: Helper.getCurrentLocal() == 'AR' ? statisticListData[pos].arName : statisticListData[pos].enName,itemValue: statisticListData[pos].value,);
                        }),
                      ),
                      state.data.charts.isEmpty? const SizedBox() :  ListView.builder(shrinkWrap: true, physics: const ClampingScrollPhysics(),itemCount:state.data.charts.length  , itemBuilder: (ctx , pos){
                        return ChartWidget(englishName: state.data.charts[pos].chartSetting.enName, araibicName: state.data.charts[pos].chartSetting.arName , chartsColors: state.data.charts[pos].finalApiData.color , precent: state.data.charts[pos].finalApiData.percent , chartData: state.data.charts[pos].chartData);
                      })
                    ],
                  ))
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Scaffold(
          appBar: isSearching ?
          PreferredSize(preferredSize: const Size.fromHeight(100),
            child: Container(
                color: AppColors.primaryColor,
                child: Padding(padding: EdgeInsets.all(10.sp) ,
                  child: TextField(
                  style: searchTextStyle,
                  showCursor: true,
                  focusNode: focusNode,
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

          )  :
          AppBar(
            title: widget.buildingName == '' ? Text(widget.companyName) : Text(widget.buildingName),
            actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    focusNode.requestFocus();
                    isSearching = true;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: Image.asset(AssetsManager.search , width: ScreenUtil().setWidth(24), height: ScreenUtil().setHeight(24),),
                ),
              ),
              GestureDetector(
                onTap: () {
                  sortDialog();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: Icon(
                    Icons.sort,
                    color: AppColors.black,
                    size: 24.sp,
                  ),
                ),
              ),
            ],
            leading: InkWell(
              child: Image.asset(AssetsManager.back , width: ScreenUtil().setWidth(14),height: ScreenUtil().setHeight(8),),
              onTap: (){
                Navigator.of(context).pop();
              },

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
