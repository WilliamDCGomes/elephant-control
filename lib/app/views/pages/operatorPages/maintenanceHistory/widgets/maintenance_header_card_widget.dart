import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_widget.dart';

class MaintenanceHeaderCardWidget extends StatelessWidget {
  final String machineName;
  final bool done;
  final bool operatorDeletedMachine;
  final bool decoratorLine;
  final BoxDecoration? decoration;
  final Color? color;
  final List<Widget> children;

  const MaintenanceHeaderCardWidget({
    Key? key,
    required this.machineName,
    required this.done,
    required this.operatorDeletedMachine,
    this.decoratorLine = false,
    this.decoration,
    this.color,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: decoration != null ? null : color ??
          (operatorDeletedMachine
              ? AppColors.redColor
              : !done
                  ? AppColors.greenColor
                  : AppColors.redColor),
      decoration: decoration,
      height: 5.h,
      width: 100.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: children.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Expanded(
              child: TextWidget(
                machineName,
                textColor: operatorDeletedMachine ? AppColors.blackColor : AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                textDecoration: decoratorLine ? TextDecoration.lineThrough : TextDecoration.none,
                textAlign: children.isEmpty ? TextAlign.center : TextAlign.start,
                maxLines: 1,
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
