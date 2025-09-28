// ignore_for_file: must_be_immutable

import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/assets_manager.dart';
import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/chart_widget.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/reports_detailes_item.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/statistic_detailes_item.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/text_item.dart';
import 'package:LandlordStatistics/widgets/aligment_widget.dart';
import 'package:LandlordStatistics/widgets/empty_data_widget.dart';
import 'package:LandlordStatistics/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../login/presentation/screen/login_screen.dart';
class StatisticDetailsScreen extends StatefulWidget {
  final String uniqueId;
  final String companyName;
  final String buildingName;
  String date;

  StatisticDetailsScreen({
    super.key,
    required this.uniqueId,
    required this.companyName,
    required this.buildingName,
    required this.date,
  });

  @override
  State<StatisticDetailsScreen> createState() => _StatisticDetailsScreenState();
}

class _StatisticDetailsScreenState extends State<StatisticDetailsScreen> {
  // ---------------- existing state ----------------
  List<StatisticColoumn> statisticListData = [];
  List<StatisticColoumn> statisticListDataDetails = [];
  bool isInitialized = false,
      isSearching = false,
      isNameSorting = false,
      isValueSorting = false;
  bool hasReports = false;
  bool hasPerm = false;
  FocusNode focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  TextStyle searchTextStyle =
  TextStyle(color: AppColors.whiteColor, fontSize: 16.sp);
  int selectedOption = 0;
  Map<String, bool> isMenuOpenMap = {};
  AlignmentWidget alignmentWidget = AlignmentWidget();

  // -------------- NEW: navbar index --------------
  int currentIndex = 0; // 0=statistics,1=charts,2=reports

  // ---------------- existing methods (unchanged) ----------------
  getData() =>
      BlocProvider.of<StatisticDetailsCubit>(context).getData(widget.uniqueId);

  void filterSearchResults(String name) {
    if (name.isEmpty) {
      setState(() {
        statisticListData = statisticListDataDetails;
      });
    }
    if (Helper.getCurrentLocal() == 'AR') {
      setState(() {
        statisticListData = statisticListData
            .where((element) =>
            element.arName.toLowerCase().contains(name.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        statisticListData = statisticListData
            .where((element) =>
            element.enName.toLowerCase().contains(name.toLowerCase()))
            .toList();
      });
    }
  }

  changeSearchingState() {
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

  void sortDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0.sp),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: ScreenUtil().setHeight(95),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(8),
                          top: ScreenUtil().setHeight(8)),
                      alignment: alignmentWidget.returnAlignment(),
                      child: Text(
                        'sortBy'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.sp),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isNameSorting = true;
                          isValueSorting = false;
                          selectedOption = 1;
                          Navigator.of(context).pop(true);
                          sortList();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'name'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.black),
                          ),
                          isNameSorting
                              ? Icon(
                            Icons.check,
                            size: 15.sp,
                            color: AppColors.black,
                          )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: AppColors.black,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isValueSorting = true;
                          isNameSorting = false;
                          selectedOption = 2;
                          Navigator.of(context).pop(true);
                          sortList();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'value'.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: AppColors.black),
                          ),
                          isValueSorting
                              ? Icon(
                            Icons.check,
                            size: 15.sp,
                            color: AppColors.black,
                          )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  sortList() {
    switch (selectedOption) {
      case 1:
        setState(() {
          if (Helper.getCurrentLocal() == 'AR') {
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

  clearData() {
    setState(() {
      statisticListData.clear();
      statisticListDataDetails.clear();
      isInitialized = false;
    });
  }

  // ------------------------- build -------------------------
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticDetailsCubit, StatisticDetailsState>(
      builder: (context, state) {
        bool localHasReports = false;

        if (state is StatisticsDetailsLoaded || state is StatisticsDetailsRefresh) {
          final data = state is StatisticsDetailsLoaded
              ? state.data
              : (state as StatisticsDetailsRefresh).data;

          final values = data.statisticColoumns.map((e) => e.value).toList();
          final columType = data.statisticColoumns.map((e) => e.columnType).toList();

          if (values.any((v) => v == " " && columType.any((element) => element == "pdf" || element == "link"))) {
            localHasReports = true;
          } else if (!columType.any((element) => element == "pdf" || element == "link")) {
            localHasReports = false;
          }
        }

        return Scaffold(
          appBar: _buildAppBar(),
          body: IndexedStack(
            index: currentIndex,
            children: [
              BlocBuilder<StatisticDetailsCubit, StatisticDetailsState>(
                builder: (context, state) {
                  return RefreshIndicator(
                      onRefresh: () async {
                        await clearData();
                        await getData();
                      },
                      child: _statisticsBody());
                },
              ),
              RefreshIndicator(
                  onRefresh: () async {
                    await clearData();
                    await getData();
                  },
                  child: _chartsBody()),
              _reportsBody(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            selectedItemColor: AppColors.primaryColor,
            onTap: (idx) => setState(() => currentIndex = idx),
            items: [
               BottomNavigationBarItem(
                icon: Icon(Icons.multiline_chart),
                label: 'statistics'.tr,
              ),
               BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline),
                label: 'charts'.tr,
              ),
              if (localHasReports)
                 BottomNavigationBarItem(
                  icon: Icon(Icons.insert_chart_outlined),
                  label: 'reports'.tr,
                ),
            ],
          ),
        );
      },
    );
  }


  // ---------------- helper: original statistic widget ----------------
  Widget _statisticsBody() {
    return BlocBuilder<StatisticDetailsCubit, StatisticDetailsState>(
      builder: (context, state) {
        if (state is StatisticsDetailsIsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StatisticsDetailsError) {
          final isUnauthenticated = state.msg.contains('Unauthenticated.');
          return ErrorWidgetItem(
            onTap: () {
              if (isUnauthenticated) {
                Get.offAll(LoginScreen(
                  addOtherMail: false,
                  isThereUsers: false,
                ));
              } else {
                getData();
              }
            },
            isUnauthenticated: isUnauthenticated,
          );
        } else if (state is StatisticsDetailsLoaded || state is StatisticsDetailsRefresh) {
          final data = state is StatisticsDetailsLoaded
              ? state.data
              : (state as StatisticsDetailsRefresh).data;


          List<StatisticColoumn> items = state is StatisticsDetailsRefresh
              ? state.statisticList.where((element) =>
              element.value.isNotEmpty &&
              element.columnType != "pdf" &&
              element.columnType != "link" &&
              element.value != " ")
              .toList()
              : data.statisticColoumns
              .where((element) =>
          element.value.isNotEmpty &&
              element.columnType != "pdf" &&
              element.columnType != "link" &&
              element.value != " ")
              .toList();

          statisticListData = items;
          statisticListDataDetails = items;

          return Container(
            margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(10),
                top: ScreenUtil().setHeight(20),
                bottom: ScreenUtil().setHeight(10)),
            child: Column(
              children: [
                Container(
                  alignment: alignmentWidget.returnAlignment(),
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
                  child: Text(
                    widget.companyName,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                        fontSize: 17.sp),
                  ),
                ),
                if (widget.buildingName.isNotEmpty)
                  TextItem(
                      image: AssetsManager.building,
                      itemName: '${'buildingName'.tr}: ',
                      itemValue: widget.buildingName),
                TextItem(
                    itemName: '${'statisticDate'.tr}: ',
                    itemValue: widget.date,
                    image: AssetsManager.date2),
                SizedBox(height: ScreenUtil().setHeight(8)),
                Expanded(
                  child: ListView(
                    children: [
                      GridView.count(
                        crossAxisCount: 1,
                        padding: EdgeInsets.zero,
                        childAspectRatio: 4,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(statisticListData.length, (pos) {
                          final col = statisticListData[pos];
                          isMenuOpenMap.putIfAbsent(col.columnName, () => false);
                          return StatisticDetailsItem(
                            isMenuOpenMap: isMenuOpenMap,
                            name: Helper.getCurrentLocal() == 'AR' ? col.arName : col.enName,
                            data: data,
                            sort: col.sort,
                            columnName: col.columnName,
                            icon: col.iconSvg,
                            statisticListData: statisticListData,
                            pos: pos,
                            uniqueId: widget.uniqueId,
                            id: col.id,
                            userColor: col.userColor.isEmpty ? col.color : col.userColor,
                            itemName: Helper.getCurrentLocal() == 'AR' ? col.arName : col.enName,
                            itemValue: col.value,
                          );
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // ---------------- charts body ----------------
  Widget _chartsBody() {
    return BlocBuilder<StatisticDetailsCubit, StatisticDetailsState>(
      builder: (context, state) {
        if (state is StatisticsDetailsLoaded) {
          final data = state.data;
          if (data.charts.isEmpty) return const EmptyDataWidget();
          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: data.charts.length,
            itemBuilder: (ctx, pos) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6, // higher elevation
                shadowColor: Colors.grey.withOpacity(0.4), // darker grey shadow
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ChartWidget(
                    englishName: data.charts[pos].chartSetting.enName,
                    araibicName: data.charts[pos].chartSetting.arName,
                    chartsColors: data.charts[pos].finalApiData.color,
                    precent: data.charts[pos].finalApiData.percent,
                    chartData: data.charts[pos].chartData,
                  ),
                ),
              ),
            ),
          );

        } else if (state is StatisticsDetailsRefresh) {
          final data = state.data;
          if (data.charts.isEmpty) return const EmptyDataWidget();
          return  ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: data.charts.length,
            itemBuilder: (ctx, pos) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ChartWidget(
                    englishName: data.charts[pos].chartSetting.enName,
                    araibicName: data.charts[pos].chartSetting.arName,
                    chartsColors: data.charts[pos].finalApiData.color,
                    precent: data.charts[pos].finalApiData.percent,
                    chartData: data.charts[pos].chartData,
                  ),
                ),
              ),
            ),
          );

        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // ---------------- reports body ----------------
  bool _isReport(StatisticColoumn e) =>
      e.columnType == "pdf" ||
          e.columnType == "link" ||
          e.value.contains('.pdf') ||
          e.value.contains('.com');

  Widget _reportsBody() {
    return BlocBuilder<StatisticDetailsCubit, StatisticDetailsState>(
      builder: (context, state) {
        if (state is StatisticsDetailsLoaded || state is StatisticsDetailsRefresh) {
          final data = state is StatisticsDetailsLoaded
              ? state.data
              : (state as StatisticsDetailsRefresh).data;

          // Try to use refreshed list only if it looks like a "reports" list.
          final emitted = state is StatisticsDetailsRefresh ? state.statisticList : data.statisticColoumns;

          final reports = (emitted.isNotEmpty && emitted.any(_isReport))
              ? emitted.where(_isReport).toList()
              : data.statisticColoumns.where(_isReport).toList();

          return Container(
            margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(10),
              left: ScreenUtil().setWidth(10),
              top: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(10),
            ),
            child: Column(
              children: [
                Container(
                  alignment: alignmentWidget.returnAlignment(),
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
                  child: Text(
                    widget.companyName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
                if (widget.buildingName.isNotEmpty)
                  TextItem(
                    image: AssetsManager.building,
                    itemName: '${'buildingName'.tr}: ',
                    itemValue: widget.buildingName,
                  ),
                TextItem(
                  itemName: '${'statisticDate'.tr}: ',
                  itemValue: widget.date,
                  image: AssetsManager.date2,
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                Expanded(
                  child: ListView(
                    children: [
                      GridView.count(
                        crossAxisCount: 1,
                        padding: EdgeInsets.zero,
                        childAspectRatio: 4,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(reports.length, (pos) {
                          final col = reports[pos];
                          isMenuOpenMap.putIfAbsent(col.columnName, () => false);

                          return ReportsDetailsItem(
                            isMenuOpenMap: isMenuOpenMap,
                            name: Helper.getCurrentLocal() == 'AR' ? col.arName : col.enName,
                            data: data,
                            sort: col.sort,
                            columnName: col.columnName,
                            icon: col.iconSvg,
                            statisticListData: reports,
                            pos: pos,
                            uniqueId: widget.uniqueId,
                            id: col.id,
                            userColor: col.userColor.isEmpty ? col.color : col.userColor,
                            itemName: Helper.getCurrentLocal() == 'AR' ? col.arName : col.enName,
                            itemValue: col.value,
                            statisticListDataFull: emitted,
                          );
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }


  PreferredSizeWidget _buildAppBar() {
    // if (isSearching) {
    //   return PreferredSize(
    //     preferredSize: const Size.fromHeight(100),
    //     child: Container(
    //         color: AppColors.primaryColor,
    //         child: Padding(
    //             padding: EdgeInsets.all(10.sp),
    //             child: TextField(
    //               style: searchTextStyle,
    //               showCursor: true,
    //               focusNode: focusNode,
    //               cursorColor: AppColors.whiteColor,
    //               onChanged: (value) {
    //                 setState(() {
    //                   filterSearchResults(value);
    //                 });
    //               },
    //               onTapOutside: (_) => changeSearchingState(),
    //               onSubmitted: (_) => changeSearchingState(),
    //               onEditingComplete: () => changeSearchingState(),
    //               controller: searchController,
    //               decoration: InputDecoration(
    //                   hintText: "Search".tr,
    //                   hintStyle: searchTextStyle,
    //                   border: InputBorder.none,
    //                   contentPadding:
    //                   EdgeInsets.only(top: ScreenUtil().setHeight(30))),
    //             ))),
    //   );
    // }
    return AppBar(
      title: widget.buildingName == ''
          ? Text(widget.companyName)
          : Text(widget.buildingName),
      // actions: [
      //   GestureDetector(
      //     onTap: () {
      //       setState(() {
      //         focusNode.requestFocus();
      //         isSearching = true;
      //       });
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.all(8.0.sp),
      //       child: Image.asset(
      //         AssetsManager.search,
      //         width: ScreenUtil().setWidth(24),
      //         height: ScreenUtil().setHeight(24),
      //       ),
      //     ),
      //   ),
      //   GestureDetector(
      //     onTap: () {
      //       sortDialog();
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.all(8.0.sp),
      //       child: Icon(
      //         Icons.sort,
      //         color: AppColors.black,
      //         size: 24.sp,
      //       ),
      //     ),
      //   ),
      // ],
      leading: InkWell(
        child: Image.asset(
          AssetsManager.back,
          width: ScreenUtil().setWidth(14),
          height: ScreenUtil().setHeight(8),
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

}
