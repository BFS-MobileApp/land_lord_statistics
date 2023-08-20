// ignore_for_file: must_be_immutable

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

  getData() =>BlocProvider.of<StatisticDetailsCubit>(context).getData(widget.uniqueId);

  @override
  void initState() {
    super.initState();
    getData();
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
            state.statisticDetails.statisticColoumn.sort((a, b) => a.sort.compareTo(b.sort));
            state.statisticDetails.statisticColoumn.removeWhere((element) => element.value =='');
            return Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) ,left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(20) , bottom: ScreenUtil().setHeight(50)),
              child: Column(
                children: [
                  TextItem(itemName: '${'company'.tr}: ', itemValue: widget.companyName),
                  widget.buildingName == '' ? const SizedBox() : TextItem(itemName: '${'buildingName'.tr}: ', itemValue: widget.companyName),
                  TextItem(itemName: '${'statisticDate'.tr}: ', itemValue: widget.date),
                  SizedBox(height: ScreenUtil().setHeight(8),),
                  Expanded(child: ListView(
                    children: [
                      GridView.count(
                        crossAxisCount: 1,
                        padding: EdgeInsets.zero,
                        childAspectRatio: 4.5,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                        shrinkWrap: true,
                        children: List.generate(state.statisticDetails.statisticColoumn.length, (pos)
                        {
                          return StatisticDetailsItem(color: state.statisticDetails.statisticColoumn[pos].color.toString(),itemName: state.statisticDetails.statisticColoumn[pos].enName,itemValue: state.statisticDetails.statisticColoumn[pos].value,);
                        }),
                      ),
                      ChartWidget(chartData: state.statisticDetails.chartData)
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
          appBar: AppBar(
              title: Text('companyData'.tr),
          ),
          body: _statisticWidget(),
        ),
        onRefresh: () => getData());
  }
}
