import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_widget.dart';

//ignore: must_be_immutable
class CityItemCardWidget extends StatelessWidget {
  final String title;
  bool isSelected;

  CityItemCardWidget({
    Key? key,
    required this.title,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        elevation: 3,
        child: Row(
          children: [
            Container(
              width: 5.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(1.5.h),
                  bottomLeft: Radius.circular(1.5.h),
                ),
                color: isSelected ? AppColors.greenColor : AppColors.redColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(1.h),
                child: TextWidget(
                  title,
                  textColor: AppColors.blackColor,
                  fontSize: 18.sp,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}