import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
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
  final int? maxLines;
  final double? latitude;
  final double? longitude;
  final bool hasIncident;

  const MaintenanceHeaderCardWidget({
    Key? key,
    required this.machineName,
    required this.done,
    required this.operatorDeletedMachine,
    this.decoratorLine = false,
    this.decoration,
    this.color,
    this.children = const [],
    this.maxLines,
    this.latitude,
    this.longitude,
    this.hasIncident = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: decoration != null
          ? null
          : color ??
              (operatorDeletedMachine
                  ? AppColors.redColor
                  : !done
                      ? AppColors.greenColor
                      : AppColors.redColor),
      decoration: decoration,
      // height: 5.h,
      width: 100.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Stack(
          children: [
            Center(
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
                      maxLines: maxLines ?? 1,
                    ),
                  ),
                  ...children,
                ],
              ),
            ),
            if (hasIncident)
              Positioned(
                right: 0,
                child: Image.asset(
                  Paths.Ocorrencia,
                  color: AppColors.whiteColor,
                  height: 2.5.h,
                  width: 2.h,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
