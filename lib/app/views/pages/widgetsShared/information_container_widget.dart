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
  final double? fontText;
  final Color textColor;
  final Color backgroundColor;
  final bool? iconInLeft;
  final bool isLoading;
  final bool showBorder;

  const InformationContainerWidget({
    Key? key,
    this.customContainer,
    this.marginContainer,
    this.marginIcon,
    this.padding,
    this.iconInLeft,
    this.fontText,
    required this.iconPath,
    required this.informationText,
    required this.textColor,
    required this.backgroundColor,
    this.isLoading = false,
    this.showBorder = false,
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
            top: PlatformType.isTablet(context) ? 9.h : 8.h,
            right: 2.h,
            bottom: 1.h,
          ),
          padding: padding ?? EdgeInsets.fromLTRB(5.w, 6.h, 5.w, 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.h),
            color: backgroundColor,
            border: showBorder ? Border.all(
              width: 1.w,
              color: AppColors.backgroundColor,
            ) : null,
          ),
          child: Visibility(
            visible: !isLoading,
            replacement: Center(child: CircularProgressIndicator(color: AppColors.whiteColor)),
            child: customContainer ??
                TextWidget(
                  informationText,
                  textColor: textColor,
                  fontSize: fontText ?? 18.sp,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Padding(
          padding: marginIcon ??
          EdgeInsets.only(
            top: 3.h,
            right: iconInLeft ?? false ? 0 : 1.w,
            left: iconInLeft ?? false ? 1.w : 0,
          ),
          child: Align(
            alignment: iconInLeft ?? false ? Alignment.topLeft : Alignment.topRight,
            child: SizedBox(
              height: 10.h,
              width: 10.h,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.h),
                  color: backgroundColor,
                  border: showBorder ? Border.all(
                    width: 1.w,
                    color: AppColors.backgroundColor,
                  ) : null,
                ),
                child: Center(
                  child: Image.asset(
                    iconPath,
                    height: 5.h,
                    width: 5.h,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
