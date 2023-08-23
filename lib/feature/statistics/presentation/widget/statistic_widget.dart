import 'dart:io';

import 'package:claimizer/config/PrefHelper/shared_pref_helper.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/feature/statistics/data/models/statistic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'statistic_item.dart';

// ignore: must_be_immutable
class StatisticWidgetItem extends StatefulWidget {
  final String buildingName;
  final String companyName;
  final String date;
  final int id;
  List<StatisticSummary> statisticList = [];
  Color color;
  int pos;
  StatisticWidgetItem({super.key, required this.pos  , required this.statisticList , required this.companyName, required this.date , required this.buildingName , required this.id , required this.color});

  @override
  State<StatisticWidgetItem> createState() => _StatisticWidgetItemState();
}

class _StatisticWidgetItemState extends State<StatisticWidgetItem> {
  final TextStyle fontStyle = TextStyle(fontWeight: FontWeight.w600 , color: AppColors.black , fontSize: 17.sp);
  late Color pickerColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    setInitialColor();
    getItemColor();
  }

  setInitialColor(){
    pickerColor = widget.color;
  }

   getItemColor() async{
    SharedPrefsHelper.getItemColor(AppStrings.companyScreen+widget.id.toString()).then((value){
      setState(() {
        if(value != const Color(0xFF44A4F2)){
          widget.statisticList[widget.pos].color = value;
          widget.color = value;
        }
      });
    });
  }

  void showColorPickerDialog(){
    showDialog(
      context: context,
      builder: (BuildContext con){
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState((){
                  widget.statisticList[widget.pos].color = pickerColor;
                  widget.color = pickerColor;
                });
                SharedPrefsHelper.setItemColor(AppStrings.companyScreen+widget.id.toString(), widget.color.value);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin:const EdgeInsets.symmetric(vertical: 10 , horizontal: 5),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius:const  BorderRadius.all(Radius.circular(15.0)),
        ),
        height: widget.buildingName == '' ? ScreenUtil().setHeight(70) : ScreenUtil().setHeight(100),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticItem(itemKey: 'company'.tr , itemValue: widget.companyName),
                InkWell(
                  onTap: ()=>showColorPickerDialog(),
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(15) , right: ScreenUtil().setWidth(15)),
                    child: Icon(Icons.settings , color: AppColors.black , size: 20.sp,),
                  ),
                )
              ],
            ),
            widget.buildingName == '' ? const SizedBox() : StatisticItem(itemKey: 'buildingName'.tr , itemValue: widget.buildingName),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10)),
              alignment: Helper.getCurrentLocal() == 'AR' ? Alignment.topRight : Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'statisticDate'.tr}: ${widget.date}' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w600 , fontSize: 13.sp),),
                  Container(
                    padding: EdgeInsets.all(3.sp),
                    width: ScreenUtil().setWidth(30),
                    height: ScreenUtil().setHeight(30),
                    decoration:  BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                  ),
                    child:  widget.buildingName == '' ? Center(child: Text(Helper.returnFirstChars(widget.companyName) , style: fontStyle,),) : Center(child: Text(Helper.returnFirstChars(widget.buildingName) , style: fontStyle)),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
