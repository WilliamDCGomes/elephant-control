import 'package:elephant_control/app/views/pages/widgetsShared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/paths.dart';
import '../../stylePages/app_colors.dart';

class StepperPagesWidget extends StatelessWidget {
  final String imagePath;
  final String firstText;
  final String secondText;
  final String thirdText;

  const StepperPagesWidget(
      { Key? key,
        required this.imagePath,
        required this.firstText,
        required this.secondText,
        required this.thirdText,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          Paths.imagesPath + imagePath,
          height: 25.h,
        ),
        Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: TextWidget(
            firstText,
            textColor: AppColors.defaultColor,
            fontSize: 21.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ),
        TextWidget(
          secondText,
          textColor: AppColors.defaultColor,
          fontSize: 18.sp,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w, top: 2.h, right: 5.w),
          child: TextWidget(
            thirdText,
            textColor: AppColors.defaultColor,
            fontSize: 16.sp,
            textAlign: TextAlign.center,
            maxLines: 10,
          ),
        ),
      ],
    );
  }
}