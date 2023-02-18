import 'package:elephant_control/app/views/pages/widgetsShared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../stylePages/app_colors.dart';

class TitleWithBackButtonWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final IconData? rightIcon;
  final Function()? onTapRightIcon;
  final Function()? backButtonPressedFuctionOverride;

  const TitleWithBackButtonWidget({
    Key? key,
    required this.title,
    this.titleColor,
    this.backButtonPressedFuctionOverride,
    this.rightIcon,
    this.onTapRightIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: .5.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: backButtonPressedFuctionOverride != null ? backButtonPressedFuctionOverride : () => Get.back(),
              child: Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: titleColor ?? AppColors.backgroundColor,
                  size: 3.h,
                ),
              ),
            ),
            Expanded(
              child: Row(children: [
                InkWell(
                  onTap: backButtonPressedFuctionOverride != null ? backButtonPressedFuctionOverride : () => Get.back(),
                  child: TextWidget(
                    title,
                    textColor: titleColor ?? AppColors.backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(child: Container()),
              ]),
            ),
            if (rightIcon != null)
              InkWell(
                onTap: onTapRightIcon,
                child: Icon(
                  rightIcon,
                  color: titleColor ?? AppColors.backgroundColor,
                  size: 3.h,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
