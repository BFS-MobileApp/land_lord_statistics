import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:claimizer/feature/statistics/presentation/widget/statistic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {

  getData() =>BlocProvider.of<StatisticCubit>(context).getData();

  @override
  void initState() {
    super.initState();
    getData();
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
            return ListView.builder(physics:const AlwaysScrollableScrollPhysics() , shrinkWrap: true ,  itemCount:state.statistic.statisticData.length , itemBuilder: (ctx , pos){
              return StatisticWidgetItem(companyName: state.statistic.statisticData[pos].companyName ,buildingName: state.statistic.statisticData[pos].buildingName,date: Helper.convertStringToDateOnly(state.statistic.statisticData[pos].statisticsDate.toString()),);
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
