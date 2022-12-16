import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_widget.dart';

class MaintenanceHeaderCardWidget extends StatelessWidget {
  final String machineName;
  final bool done;
  final RxBool operatorDeletedMachine;

  const MaintenanceHeaderCardWidget(
      { Key? key,
        required this.machineName,
        required this.done,
        required this.operatorDeletedMachine,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: operatorDeletedMachine.value ? AppColors.grayBackgroundPictureColor : done ? AppColors.greenColor : AppColors.redColor,
        height: 5.h,
        width: 100.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: Center(
            child: TextWidget(
              machineName,
              textColor: operatorDeletedMachine.value ? AppColors.blackColor : AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              textDecoration: TextDecoration.none,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}