import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;
  final Color? color;
  const IconButtonWidget({Key? key, required this.icon, this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? AppColors.whiteColor, size: 4.h),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints());
  }
}
