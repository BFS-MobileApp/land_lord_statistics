import 'package:claimizer/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticDetailsItem extends StatelessWidget {

  final String color;
  final String itemName;
  final String itemValue;
  const StatisticDetailsItem({super.key , required this.itemName , required this.itemValue , required this.color});

  Widget itemWidget(context){
    if(itemValue == ''){
      return const SizedBox();
    } else {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.returnColorFromServer(color)..withOpacity(0.35),
            borderRadius:const  BorderRadius.all(
                Radius.circular(15.0) //                 <--- border radius here
            ),
          ),
          height: ScreenUtil().setHeight(67),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(10) , right: ScreenUtil().setWidth(10) , left: ScreenUtil().setWidth(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(itemName , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 18.sp),),
                    //IconButton(onPressed: (){}, icon: FontAwesomeIcons)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10) , horizontal: ScreenUtil().setHeight(10)),
                alignment: Alignment.topLeft,
                child: Text(itemValue, style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 13.sp),),
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
