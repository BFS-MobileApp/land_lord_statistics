import 'package:LandlordStatistics/widgets/svg_image_widget.dart';
import 'package:LandlordStatistics/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:LandlordStatistics/core/utils/size_utils.dart';


class FilterLabelItem extends StatelessWidget {

  String image;
  String labelText;
  FilterLabelItem({super.key , required this.image , required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SVGImageWidget(image: image, width: 30.w, height: 30.h),
        SizedBox(width: 8.w,),
        Container(
          margin: EdgeInsets.only(top: 8.h),
          child: TextWidget(text: labelText, fontSize: 20.fSize , fontWeight: FontWeight.w600, fontColor: Theme.of(context).textTheme.bodySmall!.color,),
        )
      ],
    );
  }
}
