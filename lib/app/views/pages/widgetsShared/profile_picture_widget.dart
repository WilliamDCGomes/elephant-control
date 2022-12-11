import 'dart:io';

import 'package:elephant_control/app/views/pages/widgetsShared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/logged_user.dart';
import '../../stylePages/app_colors.dart';

class ProfilePictureWidget extends StatefulWidget {
  late final double? fontSize;
  late final RxBool loadingPicture;
  late final RxBool hasPicture;
  late final RxString profileImagePath;

  ProfilePictureWidget({
    Key? key,
    this.fontSize,
    required this.loadingPicture,
    required this.hasPicture,
    required this.profileImagePath,
  }) : super(key: key);

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => widget.loadingPicture.value ?
      SizedBox(
        height: 20.h,
        width: 20.h,
        child: CircularProgressIndicator(
          color: AppColors.backgroundColor,
        ),
      ) :
      widget.profileImagePath.value.isNotEmpty ?
      Container(
        height: 20.h,
        width: 20.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(
              File(widget.profileImagePath.value).readAsBytesSync(),
            ),
            fit: BoxFit.contain,
          ),
          shape: BoxShape.circle,
          color: AppColors.grayBackgroundPictureColor,
        ),
      ) :
      Container(
        height: 20.h,
        width: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
          color: AppColors.backgroundColor,
        ),
        child: Center(
          child: TextWidget(
            LoggedUser.nameInitials,
            textColor: AppColors.defaultColor,
            fontWeight: FontWeight.bold,
            fontSize: widget.fontSize ?? 30.sp,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
