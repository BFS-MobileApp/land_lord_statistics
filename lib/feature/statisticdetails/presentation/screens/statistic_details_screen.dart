// ignore_for_file: must_be_immutable

import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:claimizer/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:claimizer/feature/statisticdetails/presentation/widget/chart_widget.dart';
import 'package:claimizer/feature/statisticdetails/presentation/widget/text_item.dart';
import 'package:claimizer/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widget/statistic_detailes_item.dart';

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

  getData() =>BlocProvider.of<StatisticDetailsCubit>(context).getData(widget.uniqueId);

  void filterSearchResults(String name) {
    if(name.isEmpty){
      setState(() {
        statisticListData = statisticListDataDetails;
      });
    }
    setState(() {
      statisticListData = statisticListData
          .where((element) => element.enName.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
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
          statisticListData.sort((a, b) => a.enName.compareTo(b.enName));
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
            if (!isInitialized) {
              statisticListData = state.data.statisticColoumns;
              statisticListData.sort((a, b) => a.sort.compareTo(b.sort));
              statisticListData.removeWhere((element) => element.value =='');
              statisticListDataDetails = statisticListData;
              isInitialized = true;
            }
            return Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(20) , bottom: ScreenUtil().setHeight(50)),
              child: Column(
                children: [
                  TextItem(itemName: '${'company'.tr}: ', itemValue: widget.companyName),
                  widget.buildingName == '' ? const SizedBox() : TextItem(itemName: '${'buildingName'.tr}: ', itemValue: widget.buildingName),
                  TextItem(itemName: '${'statisticDate'.tr}: ', itemValue: widget.date),
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
                          return StatisticDetailsItem(icon: statisticListData[pos].iconSvg , statisticListData: statisticListData , pos: pos , uniqueId: widget.uniqueId , id: statisticListData[pos].id, color: statisticListData[pos].color.toString(),itemName: Helper.getCurrentLocal() == 'AR' ? statisticListData[pos].arName : statisticListData[pos].enName,itemValue: statisticListData[pos].value,);
                        }),
                      ),
                      ChartWidget(precent: state.data.charts.isEmpty ?[] : state.data.charts[0].finalApiData.percent , chartData: state.data.charts.isEmpty ? [] : state.data.charts[0].chartData)
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
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  sortDialog();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: const Icon(
                    Icons.sort,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: _statisticWidget(),
        ),
        onRefresh: () => getData());
  }
}
