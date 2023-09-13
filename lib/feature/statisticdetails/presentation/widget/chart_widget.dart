// ignore_for_file: must_be_immutable

import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/core/utils/hex_to_color.dart';
import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:claimizer/feature/statisticdetails/presentation/widget/chart_name_item.dart';
import 'package:claimizer/widgets/aligment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatelessWidget {

  final List<ChartDatum> chartData;
  final List<dynamic> precent;
  final List<String> chartsColors;
  List<int> roundedPercentages = [];
  String araibicName;
  String englishName;
  AlignmentWidget alignmentWidget = AlignmentWidget();
  ChartWidget({super.key , required this.englishName , required this.araibicName , required this.precent , required this.chartData , required this.chartsColors});

  List<Color> returnChartColors(){
    List<Color> colors = [];
    for(int i=0;i<chartsColors.length;i++){
      colors.add(HexToColor(chartsColors[i]));
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
    return chartData.isEmpty ? const SizedBox() :
    Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
          child: SfCircularChart(
              palette: returnChartColors(),
              title: ChartTitle(text: Helper.getCurrentLocal() == 'AR' ? araibicName : englishName),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
              //legend: const Legend(isVisible: true , ),
              series: <PieSeries<Data, String>>[
                PieSeries<Data, String>(
                    explode: true,
                    opacity: 0.9,
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
        ),
        SizedBox(height: ScreenUtil().setHeight(100) , child: ListView.builder(shrinkWrap: true,scrollDirection: Axis.vertical,itemCount:  chartData.length, itemBuilder: (ctx , pos){
          return ChartNameItem(itemColor: returnChartColors()[pos], itemName: Helper.getCurrentLocal() == 'AR' ? chartData[pos].ar : chartData[pos].en);
        })),
      ],
    );
  }
}

class Data {
  Data(this.text , this.value);
  final String text;
  final int value;
}