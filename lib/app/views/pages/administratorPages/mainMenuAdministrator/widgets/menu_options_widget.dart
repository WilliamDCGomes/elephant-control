import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';

class MenuOptionsWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final bool disable;
  final Function()? onTap;

  const MenuOptionsWidget(
      { Key? key,
        required this.text,
        required this.imagePath,
        this.disable = false,
        this.onTap,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      width: 14.h,
      child: Card(
        elevation: 3,
        color: disable ? AppColors.grayBackgroundPictureColor : AppColors.defaultColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.5.h),
        ),
        child: TextButtonWidget(
          onTap: onTap,
          borderRadius: 2.5.h,
          componentPadding: EdgeInsets.symmetric(horizontal: 1.h),
          widgetCustom: SizedBox(
            height: 13.h,
            width: 14.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    imagePath,
                    height: 6.h,
                    color: disable ? AppColors.defaultColor : AppColors.whiteColor,
                  ),
                ),
                Center(
                  child: Container(
                    height: 4.h,
                    margin: EdgeInsets.only(top: 1.h),
                    child: TextWidget(
                      text,
                      textColor: disable ? AppColors.defaultColor : AppColors.whiteColor,
                      fontSize: PlatformType.isPhone(context) ? 15.sp : 14.sp,
                      maxLines: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}