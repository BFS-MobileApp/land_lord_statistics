// ignore_for_file: must_be_immutable

import 'package:LandlordStatistics/core/utils/app_colors.dart';
import 'package:LandlordStatistics/core/utils/hex_color.dart';
import 'package:LandlordStatistics/feature/statisticdetails/data/models/statistic_details_model.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/cubit/statistic_details_cubit.dart';
import 'package:LandlordStatistics/feature/statisticdetails/presentation/widget/pdf_view_screen.dart';
import 'package:LandlordStatistics/widgets/aligment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class StatisticDetailsItem extends StatefulWidget {
  final String itemName;
  final String itemValue;
  final int id;
  final String uniqueId;
  final String icon;
  final String userColor;
  final String columnName;
  final String? name;
  List<StatisticColoumn> statisticListData;
  double sort;
  int pos;
  Data data;
  Map<String, bool> isMenuOpenMap;

  StatisticDetailsItem(
      {super.key,
        required this.isMenuOpenMap,
        this.name,
        required this.data,
        required this.sort,
        required this.columnName,
        required this.userColor,
        required this.icon,
        required this.pos,
        required this.statisticListData,
        required this.itemName,
        required this.itemValue,
        required this.id,
        required this.uniqueId});

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

  closeMenu() {
    setState(() {
      showSettingsMenu = false;
    });
  }

  void toggleSettingsMenu() {
    setState(() {
      widget.isMenuOpenMap.updateAll((key, value) => value = false);
      widget.isMenuOpenMap[widget.columnName] =
      !widget.isMenuOpenMap[widget.columnName]!;
      BlocProvider.of<StatisticDetailsCubit>(context)
          .refreshList(widget.statisticListData, widget.data);
    });
  }

  void setInitialColor() {
    setState(() {
      pickerColor = HexColor(widget.userColor);
    });
  }

  moveUp() {
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
    BlocProvider.of<StatisticDetailsCubit>(context)
        .refreshList(widget.statisticListData, widget.data);
    BlocProvider.of<StatisticDetailsCubit>(context)
        .setColumnsSettings(getColumnsSortList());
  }

  moveToBeginning() {
    toggleSettingsMenu();
    closeMenu();
    setState(() {
      final item = widget.statisticListData.removeAt(widget.pos);
      widget.statisticListData.insert(0, item);
      pos = 0;
    });
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticDetailsCubit>(context)
        .refreshList(widget.statisticListData, widget.data);
    BlocProvider.of<StatisticDetailsCubit>(context)
        .setColumnsSettings(getColumnsSortList());
  }

  moveDown() {
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
    BlocProvider.of<StatisticDetailsCubit>(context)
        .refreshList(widget.statisticListData, widget.data);
    BlocProvider.of<StatisticDetailsCubit>(context)
        .setColumnsSettings(getColumnsSortList());
  }

  moveToEnd() {
    toggleSettingsMenu();
    closeMenu();
    setState(() {
      final item = widget.statisticListData.removeAt(widget.pos);
      widget.statisticListData.add(item);
      pos = widget.statisticListData.length - 2;
    });
    widget.isMenuOpenMap.updateAll((key, value) => value = false);
    BlocProvider.of<StatisticDetailsCubit>(context)
        .refreshList(widget.statisticListData, widget.data);
    BlocProvider.of<StatisticDetailsCubit>(context)
        .setColumnsSettings(getColumnsSortList());
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

  List<String> getColumnsSortList() {
    List<String> columnsSorts = [];
    for (var columns in widget.statisticListData) {
      columnsSorts.add(columns.columnName);
    }
    return columnsSorts;
  }

  void showColorPickerDialog() {
    toggleSettingsMenu();
    showDialog(
      context: context,
      builder: (BuildContext con) {
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
                setState(() {
                  hex = '#${pickerColor.value.toRadixString(16)}';
                  widget.statisticListData[widget.pos].userColor = hex;
                  isColorChanged = true;
                });
                //BlocProvider.of<StatisticDetailsCubit>(context).setSettings(hex,  widget.columnName);
                Navigator.of(context).pop();
                widget.isMenuOpenMap.updateAll((key, value) => value = false);
                BlocProvider.of<StatisticDetailsCubit>(context)
                    .refreshList(widget.statisticListData, widget.data);
                BlocProvider.of<StatisticDetailsCubit>(context)
                    .setSettings(hex, 0, widget.columnName);
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

  Widget itemWidget(context) {
    if (widget.itemValue == '') {
      return const SizedBox();
    } else {
      return Stack(
        children: [
          GestureDetector(
            onTap: (){
              if (widget.isMenuOpenMap[widget.columnName]!) {
                widget.isMenuOpenMap.updateAll((key, value) => value = false);
                BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData, widget.data);
              } else {
                toggleSettingsMenu();
              }
            },
            child: Center(
              child: Container(
                //margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(5)),
                decoration: BoxDecoration(
                  color: HexColor(widget.userColor),
                  borderRadius: const BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: ListTile(
                  title: Text(widget.itemValue.contains("pdf") ||  widget.itemValue.contains(".com") ? widget.name!:
                  widget.itemValue ,
                    style: TextStyle(fontSize: 20.sp , fontWeight: FontWeight.w700 , color: AppColors.black),),
                  subtitle: widget.itemValue.contains("pdf") ||  widget.itemValue.contains(".com") ?  null : Text(widget.itemName , style: TextStyle(fontSize: 14.sp , fontWeight: FontWeight.w500 , color: AppColors.black),),
                  trailing: GestureDetector(
                    onTap: () async {
                      widget.isMenuOpenMap.updateAll((key, value) => value = false);
                      BlocProvider.of<StatisticDetailsCubit>(context).refreshList(widget.statisticListData, widget.data);
                      final value = widget.itemValue;
                      if (value.contains("pdf")) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfViewScreen(pdfUrl: value,name: widget.name!,),
                          ),
                        );

                      } else if (value.contains(".com")) {
                        final url = Uri.parse(value.startsWith('http') ? value : value);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          // handle error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url')),
                          );
                        }
                      }
                    },
                    child: SizedBox(
                      height: ScreenUtil().setHeight(30),
                      width: ScreenUtil().setWidth(30),
                      child: SvgPicture.string(widget.icon),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.isMenuOpenMap[widget.columnName]!)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  right: ScreenUtil().setWidth(50),
                  top: ScreenUtil().setHeight(26),
                  left: ScreenUtil().setWidth(30)),
              height: ScreenUtil().setHeight(50),
              decoration: BoxDecoration(
                  color: AppColors.offWhiteColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.color_lens),
                    iconSize: 22.sp,
                    color: AppColors.primaryColor,
                    onPressed: showColorPickerDialog,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    iconSize: 22.sp,
                    color: AppColors.primaryColor,
                    onPressed: moveUp,
                  ),
                  IconButton(
                    icon: const Icon(Icons.vertical_align_top),
                    iconSize: 22.sp,
                    color: AppColors.primaryColor,
                    onPressed: moveToBeginning,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 22.sp,
                    color: AppColors.primaryColor,
                    onPressed: () {
                      moveDown();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.vertical_align_bottom),
                    iconSize: 22.sp,
                    color: AppColors.primaryColor,
                    onPressed: moveToEnd,
                  ),
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
