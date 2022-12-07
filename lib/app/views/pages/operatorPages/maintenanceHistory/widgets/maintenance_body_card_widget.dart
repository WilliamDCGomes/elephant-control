import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';

class MaintenanceBodyCardWidget extends StatelessWidget {
  final String status;
  final String workPriority;
  final int priorityColor;

  const MaintenanceBodyCardWidget(
      { Key? key,
        required this.status,
        required this.workPriority,
        required this.priorityColor,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 5.h,
          width: 44.w,
          color: AppColors.grayBackgroundPictureColor,
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
          child: Center(
            child: RichTextTwoDifferentWidget(
              firstText: "Prioridade: ",
              firstTextColor: AppColors.blackColor,
              firstTextFontWeight: FontWeight.normal,
              firstTextSize: 14.5.sp,
              secondText: workPriority,
              secondTextColor: Color(priorityColor),
              secondTextFontWeight: FontWeight.bold,
              secondTextSize: 14.5.sp,
              secondTextDecoration: TextDecoration.none,
            ),
          ),
        ),
        Container(
          height: 5.h,
          width: 44.w,
          color: AppColors.grayBackgroundPictureColor,
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: RichTextTwoDifferentWidget(
                    firstText: "Status: ",
                    firstTextColor: AppColors.blackColor,
                    firstTextFontWeight: FontWeight.normal,
                    firstTextSize: 14.5.sp,
                    secondText: status,
                    secondTextColor: AppColors.blackColor,
                    secondTextFontWeight: FontWeight.bold,
                    secondTextSize: 14.5.sp,
                    secondTextDecoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}