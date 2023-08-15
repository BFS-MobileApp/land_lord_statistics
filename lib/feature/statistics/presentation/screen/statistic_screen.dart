import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/statistics/data/models/statistic_model.dart';
import 'package:claimizer/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:claimizer/feature/statistics/presentation/widget/statistic_widget.dart';
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
  bool isInitialized = false;


  getData() =>BlocProvider.of<StatisticCubit>(context).getData();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void filterSearchResults(String name) {
    debugPrint('textFieldValue in function $name');
    if(name.isEmpty){
      setState(() {
        statisticList = statisticListData;
      });
    }
    setState(() {
      statisticList = statisticListData
          .where((element) => element.companyName.toLowerCase().contains(name.toLowerCase()))
          .toList();
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
            return ErrorWidget(()=>getData());
          } else if (state is StatisticsLoaded) {
            if (!isInitialized) {
              statisticList = state.statistic.statisticData;
              statisticListData = state.statistic.statisticData;
              isInitialized = true;
            }
            debugPrint('hi ${statisticList.length}');
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(10.sp) , child: TextField(
                    onChanged: (value){
                      debugPrint('textFieldValue$value');
                      filterSearchResults(value);
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                        labelText: "search".tr,
                        hintText: "Search".tr,
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                  ),),
                  ListView.builder(physics:const NeverScrollableScrollPhysics() , shrinkWrap: true ,  itemCount:statisticList.length , itemBuilder: (ctx , pos){
                    return StatisticWidgetItem(companyName: statisticList[pos].companyName ,buildingName: statisticList[pos].buildingName,date: Helper.convertStringToDateOnly(statisticList[pos].statisticsDate.toString()),);
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
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Scaffold(
          appBar: AppBar(
            title: Text('companies'.tr),
          ),
          body: _statisticWidget(),
        ),
        onRefresh: () => getData());
  }
}
