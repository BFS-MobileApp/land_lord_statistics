import 'package:claimizer/config/PrefHelper/shared_pref_helper.dart';
import 'package:claimizer/core/utils/app_colors.dart';
import 'package:claimizer/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticDetailsItem extends StatefulWidget {

  final String color;
  final String itemName;
  final String itemValue;
  final int id;
  final String uniqueId;
  const StatisticDetailsItem({super.key , required this.itemName , required this.itemValue , required this.color , required this.id , required this.uniqueId});

  @override
  State<StatisticDetailsItem> createState() => _StatisticDetailsItemState();
}

class _StatisticDetailsItemState extends State<StatisticDetailsItem> {

  late Color pickerColor;
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    setInitialColor();
    getItemColor();
  }

  getItemColor() async{
    SharedPrefsHelper.getItemColor(widget.uniqueId+widget.id.toString()).then((value){
      setState(() {
        currentColor = value;
      });
    });
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void setInitialColor(){
    pickerColor = AppColors.returnColorFromServer(widget.color);
    currentColor = AppColors.returnColorFromServer(widget.color);
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
                setState(() => currentColor = pickerColor);
                SharedPrefsHelper.setItemColor(widget.uniqueId+widget.id.toString(), currentColor.value);
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
            color: currentColor,
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(10)),
                alignment: Helper.getCurrentLocal() == 'AR' ? Alignment.topRight : Alignment.topLeft,
                child: Text(widget.itemValue, style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 13.sp),),
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
