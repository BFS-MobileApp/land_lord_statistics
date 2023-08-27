import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatelessWidget {

  final List<ChartDatum> chartData;
  final List<dynamic> precent;
  final List<String> chartsColors;
  List<int> roundedPercentages = [];
  ChartWidget({super.key , required this.precent , required this.chartData , required this.chartsColors});

  List<Color> returnChartColors(){
    List<Color> colors = [];
    for(int i=0;i<chartsColors.length;i++){
      colors.add(AppColors.returnColorFromServer(chartsColors[i]));
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    roundedPercentages = precent.map((value) {
      if (value is int) {
        return value;
      } else if (value is double) {
        return value.round();
      }
      return null;
    }).whereType<int>().toList();
    return chartData.isEmpty ? const SizedBox() : Center(
      child: SfCircularChart(
          palette: returnChartColors(),
          title: ChartTitle(text: 'chartWidgetPhase'.tr),
          //legend: const Legend(isVisible: true),
          series: <PieSeries<Data, String>>[
            PieSeries<Data, String>(
                explode: true,
                explodeIndex: 0,
                dataSource: <Data>[
                  for(int i=0;i<precent.length;i++) Data('${precent[i].toStringAsFixed(2)}%' , roundedPercentages[i]),
                ],
                xValueMapper: ( Data data, _) => data.text,
                yValueMapper: ( Data data, _) => data.value,
                dataLabelMapper: ( Data data, _) => data.text,
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
          ]
      ),
    );
  }
}

class Data {
  Data(this.text , this.value);
  final String text;
  final int value;
}