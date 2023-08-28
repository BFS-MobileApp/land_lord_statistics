// ignore_for_file: must_be_immutable

import 'package:claimizer/config/PrefHelper/shared_pref_helper.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/hex_color.dart';
import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:claimizer/widgets/aligment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StatisticDetailsItem extends StatefulWidget {

  final String color;
  final String itemName;
  final String itemValue;
  final int id;
  final String uniqueId;
  final String icon;
  List<StatisticColoumn> statisticListData;
  int pos;
  StatisticDetailsItem({super.key , required this.icon , required this.pos , required this.statisticListData , required this.itemName , required this.itemValue , required this.color , required this.id , required this.uniqueId});

  @override
  State<StatisticDetailsItem> createState() => _StatisticDetailsItemState();
}

class _StatisticDetailsItemState extends State<StatisticDetailsItem> {

  late Color pickerColor;
  AlignmentWidget alignmentWidget = AlignmentWidget();

  @override
  void initState() {
    super.initState();
    setInitialColor();
    getItemColor();
  }

  getItemColor() async{
    SharedPrefsHelper.getItemColor(widget.uniqueId+widget.id.toString()).then((value){
      setState(() {
        widget.statisticListData[widget.pos].savedColor = value;
      });
    });
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void setInitialColor(){
    pickerColor = HexColor(widget.color);
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
                  widget.statisticListData[widget.pos].savedColor = pickerColor;
                });
                SharedPrefsHelper.setItemColor(widget.uniqueId+widget.id.toString(), widget.statisticListData[widget.pos].savedColor.value);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget itemWidget(context){
    if(widget.itemValue == ''){
      return const SizedBox();
    } else {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: widget.statisticListData[widget.pos].savedColor,
            borderRadius:const  BorderRadius.all(
                Radius.circular(15.0) //                 <--- border radius here
            ),
          ),
          height: ScreenUtil().setHeight(70),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(widget.itemName ,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 18.sp),)),
                    IconButton(
                        onPressed: ()=>showColorPickerDialog(),
                        icon: Icon(Icons.settings , color: AppColors.black , size: 20.sp,))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12)),
                    alignment: alignmentWidget.returnAlignment(),
                    child: Text(widget.itemValue, style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 13.sp),),
                  ),
                  Container(
                    height: ScreenUtil().setHeight(20),
                    width: ScreenUtil().setWidth(20),
                    margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(20)),
                    alignment: alignmentWidget.returnAlignment(),
                    child: SvgPicture.string(widget.icon),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return itemWidget(context);
  }
}
