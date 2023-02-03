import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../stylePages/app_colors.dart';
import '../text_widget.dart';

class DefaultPopupWidget extends StatefulWidget {
  final String? title;
  final double? fontSize;
  final Color? popupColor;
  final List<Widget>? children;
  final CrossAxisAlignment? crossAxisAlignment;

  const DefaultPopupWidget({
    Key? key,
    this.title,
    this.fontSize,
    this.popupColor,
    this.children,
    this.crossAxisAlignment,
  }) : super(key: key);

  @override
  State<DefaultPopupWidget> createState() => _DefaultPopupWidgetState();
}

class _DefaultPopupWidgetState extends State<DefaultPopupWidget> {
  late bool showPopup;

  @override
  void initState() {
    showPopup = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 150));
      setState(() {
        showPopup = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Visibility(
        visible: showPopup,
        child: SizedBox(
          height: 50.h,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: Container(
              width: 75.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(1.h),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 90.w,
                    padding: EdgeInsets.all(2.h),
                    decoration: BoxDecoration(
                      color: widget.popupColor ?? AppColors.defaultColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(1.h),
                        topLeft: Radius.circular(1.h),
                      ),
                    ),
                    child: TextWidget(
                      widget.title ?? "AVISO",
                      textColor: AppColors.whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...?widget.children,
                  // Padding(
                  //   padding: EdgeInsets.only(top: 2.h),
                  //   child: Center(
                  //     child: ButtonWidget(
                  //       hintText: "OK",
                  //       heightButton: 5.h,
                  //       widthButton: 32.w,
                  //       fontWeight: FontWeight.bold,
                  //       backgroundColor: widget.popupColor,
                  //       borderColor: widget.popupColor,
                  //       onPressed: () => Get.back(),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
