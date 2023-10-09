// ignore_for_file: must_be_immutable

import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/hex_color.dart';
import 'package:claimizer/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:claimizer/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:claimizer/widgets/aligment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StatisticDetailsItem extends StatefulWidget {

  final String itemName;
  final String itemValue;
  final int id;
  final String uniqueId;
  final String icon;
  final String userColor;
  final String columnName;
  List<StatisticColoumn> statisticListData;
  double sort;
  int pos;
  Data data;
  Map<String, bool> isMenuOpenMap;
  StatisticDetailsItem({super.key ,required this.isMenuOpenMap,  required this.data , required this.sort , required this.columnName , required this.userColor , required this.icon , required this.pos , required this.statisticListData , required this.itemName , required this.itemValue , required this.id , required this.uniqueId});

  @override
  State<StatisticDetailsItem> createState() => _StatisticDetailsItemState();
}

class _StatisticDetailsItemState extends State<StatisticDetailsItem> {

  late Color pickerColor;
  AlignmentWidget alignmentWidget = AlignmentWidget();
  var hex;
  bool showSettingsMenu = false, isColorChanged = false;
  int pos = -2;

  @override
  void initState() {
    super.initState();
    setInitialColor();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  closeMenu(){
    setState(() {
      showSettingsMenu = false;
    });
  }

  void toggleSettingsMenu() {
    setState(() {
      widget.isMenuOpenMap.updateAll((key, value) => value = false);
      widget.isMenuOpenMap[widget.columnName] = !widget.isMenuOpenMap[widget.columnName]!;
      BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData , widget.data);
    });
  }

  void setInitialColor(){
    setState(() {
      pickerColor = HexColor(widget.userColor);
    });
  }

  moveUp(){
    toggleSettingsMenu();
    closeMenu();
    if (widget.pos > 0) {
      setState(() {
        final item = widget.statisticListData.removeAt(widget.pos);
        widget.statisticListData.insert(widget.pos - 1, item);
        pos = widget.pos;
      });
    }
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData , widget.data);
    BlocProvider.of<StatisticDetailsCubit>(context).setColumnsSettings(getColumnsSortList());
  }

  moveToBeginning(){
    toggleSettingsMenu();
    closeMenu();
    setState(() {
      final item = widget.statisticListData.removeAt(widget.pos);
      widget.statisticListData.insert(0, item);
      pos = 0;
    });
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData , widget.data);
    BlocProvider.of<StatisticDetailsCubit>(context).setColumnsSettings(getColumnsSortList());
  }

  moveDown(){
    toggleSettingsMenu();
    closeMenu();
    if (widget.pos < widget.statisticListData.length - 1) {
      setState(() {
        final item = widget.statisticListData.removeAt(widget.pos);
        widget.statisticListData.insert(widget.pos + 1, item);
        pos = widget.pos;
      });
    }
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData , widget.data);
    BlocProvider.of<StatisticDetailsCubit>(context).setColumnsSettings(getColumnsSortList());
  }

  moveToEnd(){
    toggleSettingsMenu();
    closeMenu();
    setState(() {
      final item = widget.statisticListData.removeAt(widget.pos);
      widget.statisticListData.add(item);
      pos = widget.statisticListData.length-2;
    });
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData , widget.data);
    BlocProvider.of<StatisticDetailsCubit>(context).setColumnsSettings(getColumnsSortList());
  }

  /*refreshList(){
    BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData , widget.data);
    if(isColorChanged == false && pos != -2){
      BlocProvider.of<StatisticDetailsCubit>(context).setSettings('', pos+1 , widget.uniqueId);
    } else if(isColorChanged == true && pos != -2){
      BlocProvider.of<StatisticDetailsCubit>(context).setSettings(hex, pos+1 , widget.uniqueId);
    } else if(isColorChanged == true && pos == -2){
      BlocProvider.of<StatisticDetailsCubit>(context).setSettings(hex, widget.sort , widget.uniqueId);
    }
  }*/
  
  List<String> getColumnsSortList(){
    List<String> columnsSorts = [];
    for(var columns in widget.statisticListData){
      columnsSorts.add(columns.columnName);
    }
    return columnsSorts;
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
                  hex = '#${pickerColor.value.toRadixString(16)}';
                  widget.statisticListData[widget.pos].userColor = hex ;
                  isColorChanged = true;
                });
                //BlocProvider.of<StatisticDetailsCubit>(context).setSettings(hex,  widget.columnName);
                Navigator.of(context).pop();
                widget.isMenuOpenMap.updateAll((key, value) => value = false);
                BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData , widget.data);
                BlocProvider.of<StatisticDetailsCubit>(context).setSettings(hex, 0 , widget.columnName);
              },
            ),
          ],
        );
      },
    );
  }

  int _countWords(String text) {
    return text.split(' ').where((word) => word.isNotEmpty).length;
  }

  Widget itemWidget(context){
    if(widget.itemValue == ''){
      return const SizedBox();
    } else {
      return Stack(
        children: [
          GestureDetector(
            onTap: toggleSettingsMenu,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor(widget.userColor),
                  borderRadius:const  BorderRadius.all(
                      Radius.circular(15.0) //                 <--- border radius here
                  ),
                ),
                height: ScreenUtil().setHeight(75),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10) , horizontal: ScreenUtil().setWidth(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(widget.itemName ,
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: _countWords(widget.itemName) <=6 ? 18.sp : 15.sp),)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(12) , right: ScreenUtil().setWidth(12) , bottom: ScreenUtil().setHeight(12)),
                          alignment: alignmentWidget.returnAlignment(),
                          child: Text(widget.itemValue, style: TextStyle(color: Colors.black , fontWeight: FontWeight.w600 , fontSize: 13.sp),),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(20),
                          width: ScreenUtil().setWidth(20),
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(12) , right: ScreenUtil().setWidth(12) , bottom: ScreenUtil().setHeight(12)),
                          alignment: alignmentWidget.returnAlignment(),
                          child: SvgPicture.string(widget.icon),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          if(widget.isMenuOpenMap[widget.columnName]!)
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

  @override
  Widget build(BuildContext context) {
    return itemWidget(context);
  }
}
