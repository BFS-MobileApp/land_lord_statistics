import 'package:claimizer/config/PrefHelper/shared_pref_helper.dart';
import 'package:claimizer/core/utils/app_strings.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/feature/statistics/data/models/statistic_model.dart';
import 'package:claimizer/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:claimizer/widgets/aligment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  StatisticWidgetItem({super.key, required this.pos , required this.statisticList , required this.companyName, required this.date , required this.buildingName , required this.id , required this.color});

  @override
  State<StatisticWidgetItem> createState() => _StatisticWidgetItemState();
}

class _StatisticWidgetItemState extends State<StatisticWidgetItem> {
  final TextStyle fontStyle = TextStyle(fontWeight: FontWeight.w600 , color: AppColors.black , fontSize: 17.sp);
  late Color pickerColor;
  AlignmentWidget alignmentWidget = AlignmentWidget();
  bool showSettingsMenu = false, isColorChanged = false;
  int pos = -1;


  void toggleSettingsMenu() {
    setState(() {
      showSettingsMenu = !showSettingsMenu;
      print(showSettingsMenu);
    });
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    super.initState();
    setInitialColor();
  }

  setInitialColor(){
    if(widget.color == const Color(0x00ffffff)){
      setState(() {
        widget.color = AppColors.colors[Helper.index(7)];
        pickerColor = widget.color;
      });
    }
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    setInitialColor();
  }

  void showColorPickerDialog(){
    toggleSettingsMenu();
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
                  widget.statisticList[widget.pos].colorValue = pickerColor;
                  widget.color = pickerColor;
                  isColorChanged = true;
                });
                SharedPrefsHelper.setItemColor(AppStrings.companyScreen+widget.id.toString(), widget.color.value);
                Navigator.of(context).pop();
                refreshList();
              },
            ),
          ],
        );
      },
    );
  }

  refreshList(){
    BlocProvider.of<StatisticCubit>(context).refreshList(widget.statisticList);
    if(isColorChanged == false && pos != -1){
      BlocProvider.of<StatisticCubit>(context).setSettings(widget.statisticList[widget.pos].colorValue.toString(), pos , widget.statisticList[widget.pos].uniqueValue);
    } else if(isColorChanged == true && pos != -1){
      BlocProvider.of<StatisticCubit>(context).setSettings(widget.color.value.toString(), pos , widget.statisticList[widget.pos].uniqueValue);
    } else if(isColorChanged == true && pos == -1){
      BlocProvider.of<StatisticCubit>(context).setSettings(widget.color.value.toString(), pos , widget.statisticList[widget.pos].uniqueValue);
    }
  }

  moveUp(){
    toggleSettingsMenu();
    if (widget.pos > 0) {
      setState(() {
        final item = widget.statisticList.removeAt(widget.pos);
        widget.statisticList.insert(widget.pos - 1, item);
        pos = widget.pos;
      });
    }
    refreshList();
  }

  moveToBeginning(){
    toggleSettingsMenu();
    setState(() {
      final item = widget.statisticList.removeAt(widget.pos);
      widget.statisticList.insert(0, item);
      pos = widget.pos;
    });
    refreshList();
  }

  moveDown(){
    toggleSettingsMenu();
    print('here');
    if (widget.pos < widget.statisticList.length - 1) {
      setState(() {
        final item = widget.statisticList.removeAt(widget.pos);
        print(item.companyName);
        widget.statisticList.insert(widget.pos + 1, item);
        pos = widget.pos;
      });
    }
    refreshList();
  }

  moveToEnd(){
    toggleSettingsMenu();
    setState(() {
      final item = widget.statisticList.removeAt(widget.pos);
      widget.statisticList.add(item);
      pos = widget.pos;
    });
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
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
                    GestureDetector(
                      onTap: toggleSettingsMenu,
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
                  alignment: alignmentWidget.returnAlignment(),
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
        ),
        if(showSettingsMenu)
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(50) , top: ScreenUtil().setHeight(15) , left: ScreenUtil().setWidth(30)),
            height: ScreenUtil().setHeight(50),
            color: AppColors.offWhiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.color_lens) , iconSize: 22.sp, onPressed: showColorPickerDialog,),
                IconButton(icon: const Icon(Icons.arrow_upward) , iconSize: 22.sp, onPressed: moveUp,),
                IconButton(icon: const Icon(Icons.vertical_align_top) , iconSize: 22.sp, onPressed: moveToBeginning,),
                IconButton(icon: const Icon(Icons.arrow_downward) , iconSize: 22.sp, onPressed: (){moveDown();},),
                IconButton(icon: const Icon(Icons.vertical_align_bottom) , iconSize: 22.sp, onPressed: moveToEnd,),
              ],
            ),
          )
      ],
    );
  }
}
