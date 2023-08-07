import 'package:claimizer/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {

  getData() =>BlocProvider.of<StatisticCubit>(context).getData();

  Widget _data(){
    return BlocBuilder<StatisticCubit , StatisticState>(builder: (context , state){
      if(state is StatisticsIsLoading){
        return const Center(child: CircularProgressIndicator(),);
      }
      else if(state is StatisticsError){
        return ErrorWidget(getData());
      } else if(state is StatisticsLoaded){
        
      } else {
        return const SizedBox();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: _data(),
    );
  }
}
