import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/map_utils.dart';
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
      height: 5.h,
      width: 100.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: children.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
            Visibility(
              visible: latitude != null && latitude != "" && longitude != null && longitude != "",
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => MapUtils.openMap(latitude, longitude),
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w, right: 1.w),
                    child: Icon(
                      Icons.map,
                      color: AppColors.whiteColor,
                      size: 3.h,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
