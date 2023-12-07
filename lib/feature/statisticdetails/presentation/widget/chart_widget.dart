// ignore_for_file: must_be_immutable

import 'package:LandlordStatistics/core/utils/helper.dart';
import 'package:LandlordStatistics/core/utils/hex_to_color.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/chart_name_item.dart';
import 'package:LandlordStatistics/widgets/aligment_widget.dart';
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

  void removeEmptyData(){
    precent.removeWhere((value) => value == null || value == 0);
    chartData.removeWhere((element) => element.value == 0 || element.value == null);
  }

  @override
  Widget build(BuildContext context) {
    removeEmptyData();
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
              series: <PieSeries<Data, String>>[
                PieSeries<Data, String>(
                    explode: true,
                    opacity: 0.9,
                    explodeIndex: 0,
                    dataSource: <Data>[
                      for(int i=0;i<precent.length;i++) precent[i] == null ? Data('0%' , 0) : Data('${precent[i].toStringAsFixed(2)}%' , roundedPercentages[i]),
                    ],
                    xValueMapper: ( Data data, _) => data.text,
                    yValueMapper: ( Data data, _) => data.value,
                    dataLabelMapper: ( Data data, _) => data.text,
                    dataLabelSettings: const DataLabelSettings(isVisible: true)),
              ]
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(80) , child: ListView.builder(shrinkWrap: true,scrollDirection: Axis.vertical,itemCount:  chartData.length, itemBuilder: (ctx , pos){
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