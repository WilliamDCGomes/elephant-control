import 'package:elephant_control/app/views/pages/widgetsShared/text_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/platform_type.dart';

class InformationContainerWidget extends StatelessWidget {
  final Widget? customContainer;
  final EdgeInsets? marginContainer;
  final EdgeInsets? marginIcon;
  final EdgeInsets? padding;
  final String iconPath;
  final String informationText;
  final Color textColor;
  final Color backgroundColor;
  final bool? iconInLeft;
  final bool isLoading;

  const InformationContainerWidget({
    Key? key,
    this.customContainer,
    this.marginContainer,
    this.marginIcon,
    this.padding,
    this.iconInLeft,
    required this.iconPath,
    required this.informationText,
    required this.textColor,
    required this.backgroundColor,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: marginContainer ??
              EdgeInsets.only(
                left: 2.h,
                top: PlatformType.isTablet(context) ? 9.h : 7.h,
                right: 2.h,
                bottom: 1.h,
              ),
          padding: padding ?? EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 3.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.h),
            color: backgroundColor,
          ),
          child: Visibility(
            visible: !isLoading,
            replacement: Center(child: CircularProgressIndicator(color: AppColors.whiteColor)),
            child: customContainer ??
                TextWidget(
                  informationText,
                  textColor: textColor,
                  fontSize: 18.sp,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Align(
          alignment: iconInLeft ?? false ? Alignment.topLeft : Alignment.topRight,
          child: Container(
            padding: EdgeInsets.all(2.h),
            margin: marginIcon ??
                EdgeInsets.only(
                  top: PlatformType.isTablet(context) ? 4.h : 2.h,
                  right: iconInLeft ?? false ? 0 : 1.w,
                  left: iconInLeft ?? false ? 1.w : 0,
                ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.5.h),
              color: backgroundColor,
            ),
            child: Image.asset(
              iconPath,
              height: 5.h,
              width: 5.h,
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}
