import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BotaoCameraWidget extends StatelessWidget {
  final void Function()? onPressed;
  final AlignmentGeometry? alignment;
  final IconData icon;
  final double? radius;
  final double? size;
  const BotaoCameraWidget({Key? key, this.onPressed, this.alignment, required this.icon, this.radius, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.topLeft,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 0.25.h, horizontal: 0.25.w),
          padding: EdgeInsets.symmetric(vertical: 0.25.h, horizontal: 0.25.w),
          decoration: BoxDecoration(
            color: AppColors.blackColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
              icon: Icon(
                icon,
                color: AppColors.whiteColor,
                size: size ?? 3.h,
              ),
              onPressed: onPressed,
              // constraints: const BoxConstraints(),
              padding: EdgeInsets.zero)),
    );
  }
}
