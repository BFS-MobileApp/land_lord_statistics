import 'package:LandlordStatistics/core/utils/assets_manager.dart';
import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/feature/statistics/data/models/statistic_model.dart';
import 'package:LandlordStatistics/feature/statistics/presentation/cubit/statistic_cubit.dart';
import 'package:LandlordStatistics/widgets/aligment_widget.dart';
import 'package:LandlordStatistics/widgets/svg_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'statistic_item.dart';

// ignore: must_be_immutable
class StatisticWidgetItem extends StatefulWidget {
  final String buildingName;
  final String companyName;
  final String date;
  final String uniqueId;
  List<StatisticSummary> statisticList = [];
  Color color;
  int pos;
  //dynamic sort;
  dynamic maxSort;
  dynamic minSort;
  Map<String, bool> isMenuOpenMap;
  StatisticWidgetItem({super.key, required this.maxSort , required this.isMenuOpenMap , required this.minSort , required this.pos , required this.statisticList , required this.companyName, required this.date , required this.buildingName , required this.uniqueId , required this.color});

  @override
  State<StatisticWidgetItem> createState() => _StatisticWidgetItemState();
}

class _StatisticWidgetItemState extends State<StatisticWidgetItem> {
  final TextStyle fontStyle = TextStyle(fontWeight: FontWeight.w600 , color: AppColors.black , fontSize: 17.sp);
  late Color pickerColor;
  AlignmentWidget alignmentWidget = AlignmentWidget();
  bool showSettingsMenu = false, isColorChanged = false;
  int pos = -2;
  var hex;
  double previousSort = 0.0, nextSort = 0.0;

  void toggleSettingsMenu() {
    setState(() {
      widget.isMenuOpenMap.updateAll((key, value) => value = false);
      BlocProvider.of<StatisticCubit>(context).refreshList(widget.statisticList);
      widget.isMenuOpenMap[widget.uniqueId] = !widget.isMenuOpenMap[widget.uniqueId]!;
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

  List<String> getCompaniesSortId(){
    List<String> companiesSort = [];
    for(var company in widget.statisticList){
      companiesSort.add(company.uniqueValue);
    }
    return companiesSort;
  }

  setInitialColor(){
    setState(() {
      pickerColor = widget.color;
    });
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
                  hex = '#${pickerColor.value.toRadixString(16)}';
                  isColorChanged = true;
                });
                Navigator.of(context).pop();
                widget.isMenuOpenMap.updateAll((key, value) => value = false);
                BlocProvider.of<StatisticCubit>(context).setSettings(hex, 0 , widget.uniqueId);
                //refreshList(sort);
              },
            ),
          ],
        );
      },
    );
  }

  Color intColorToColor(int intColor) {
    return Color(intColor);
  }

  String colorToHex(Color color) {
    String hexColor = '#${color.value.toRadixString(16).toUpperCase()}';
    return hexColor.padLeft(9, '0');
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
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticCubit>(context).refreshList(widget.statisticList);
    BlocProvider.of<StatisticCubit>(context).setCompanySort(getCompaniesSortId());
  }

  moveToBeginning(){
    toggleSettingsMenu();
    setState(() {
      final item = widget.statisticList.removeAt(widget.pos);
      widget.statisticList.insert(0, item);
      pos = 0;
    });
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticCubit>(context).refreshList(widget.statisticList);
    BlocProvider.of<StatisticCubit>(context).setCompanySort(getCompaniesSortId());
  }

  moveDown(){
    toggleSettingsMenu();
    if (widget.pos < widget.statisticList.length - 1) {
      setState(() {
        final item = widget.statisticList.removeAt(widget.pos);
        widget.statisticList.insert(widget.pos + 1, item);
        pos = widget.pos;
      });
    }
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticCubit>(context).refreshList(widget.statisticList);
    BlocProvider.of<StatisticCubit>(context).setCompanySort(getCompaniesSortId());
  }

  moveToEnd(){
    toggleSettingsMenu();
    setState(() {
      final item = widget.statisticList.removeAt(widget.pos);
      widget.statisticList.add(item);
      pos = widget.statisticList.length-2;
    });
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticCubit>(context).refreshList(widget.statisticList);
    BlocProvider.of<StatisticCubit>(context).setCompanySort(getCompaniesSortId());
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
              borderRadius:const  BorderRadius.all(Radius.circular(5.0)),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(10) , right: ScreenUtil().setWidth(10) , top: ScreenUtil().setHeight(9) , bottom: ScreenUtil().setHeight(4)),
                      child: Text(widget.companyName ,
                        softWrap: false,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis ,
                        style: TextStyle(color: Colors.black , fontWeight: FontWeight.w600 , fontSize: 16.sp),),
                    )),
                    GestureDetector(
                      onTap: (){
                        if(widget.isMenuOpenMap[widget.uniqueId]!){
                          widget.isMenuOpenMap.updateAll((key, value) => value = false);
                          BlocProvider.of<StatisticCubit>(context).refreshList(widget.statisticList);
                        } else {
                          toggleSettingsMenu();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(10) , right: ScreenUtil().setWidth(10)),
                        child: const SVGImageWidget(image: AssetsManager.settingSVG,height: 24,width: 24,),
                      ),
                    )
                  ],
                ),
                widget.buildingName == '' ? const SizedBox() : Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10) , bottom: ScreenUtil().setHeight(5)),
                  alignment: alignmentWidget.returnAlignment(),
                  child: Row(
                    children: [
                      const SVGImageWidget(image: AssetsManager.homeSVG,height: 18,width: 18,),
                      SizedBox(width: ScreenUtil().setWidth(7),),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(3)),
                        child: Text(widget.buildingName ,
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis ,
                          style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 14.sp),),
                      )
                    ],
                  ),
                ),
                StatisticItem(image:  AssetsManager.dateSVG, itemValue: widget.date),
              ],
            ),
          ),
        ),
        if(widget.isMenuOpenMap[widget.uniqueId]!)
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(80) , top: widget.buildingName == '' ? ScreenUtil().setHeight(28) : ScreenUtil().setHeight(58) , left: ScreenUtil().setWidth(50)),
            height: ScreenUtil().setHeight(40),
            decoration: BoxDecoration(
              color: AppColors.offWhiteColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.color_lens) , color: AppColors.primaryColor ,  iconSize: 22.sp, onPressed: showColorPickerDialog,),
                IconButton(icon: const Icon(Icons.arrow_upward) , color: AppColors.primaryColor , iconSize: 22.sp, onPressed: moveUp,),
                IconButton(icon: const Icon(Icons.vertical_align_top) , color: AppColors.primaryColor , iconSize: 22.sp, onPressed: moveToBeginning,),
                IconButton(icon: const Icon(Icons.arrow_downward) , color: AppColors.primaryColor , iconSize: 22.sp, onPressed: (){moveDown();},),
                IconButton(icon: const Icon(Icons.vertical_align_bottom) , color: AppColors.primaryColor , iconSize: 22.sp, onPressed: moveToEnd,),
              ],
            ),
          )
      ],
    );
  }
}
