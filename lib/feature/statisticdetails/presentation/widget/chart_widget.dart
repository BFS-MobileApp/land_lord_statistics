import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatelessWidget {

  final List<ChartDatum> chartData;
  const ChartWidget({super.key , required this.chartData});


  @override
  Widget build(BuildContext context) {
    return chartData.isEmpty ? const SizedBox() : Center(
      child: SfCircularChart(
          title: ChartTitle(text: 'Charts For Statistics'),
          //legend: const Legend(isVisible: true),
          series: <PieSeries<Data, String>>[
            PieSeries<Data, String>(
                explode: true,
                explodeIndex: 0,
                dataSource: <Data>[
                  for(int i=0;i<chartData.length;i++) Data('${chartData[i].value}%' , chartData[i].value),
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