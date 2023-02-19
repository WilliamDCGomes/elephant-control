import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../stylePages/app_colors.dart';
import '../button_widget.dart';
import '../text_widget.dart';

class ConfirmationPopup extends StatefulWidget {
  final bool? showSecondButton;
  final String title;
  final String? subTitle;
  final Widget? child;
  final String? firstButtonText;
  final String? secondButtonText;
  final Function firstButton;
  final Function secondButton;

  const ConfirmationPopup({
    Key? key,
    required this.title,
    this.showSecondButton,
    this.subTitle,
    this.firstButtonText,
    this.secondButtonText,
    required this.firstButton,
    required this.secondButton,
    this.child,
  }) : super(key: key);

  @override
  State<ConfirmationPopup> createState() => _ConfirmationPopupState();
}

class _ConfirmationPopupState extends State<ConfirmationPopup> {
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
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.h),
          ),
          child: Container(
            width: 75.w,
            height: widget.child == null ? null : 35.h,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90.w,
                  padding: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                    color: AppColors.defaultColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(1.h),
                      topLeft: Radius.circular(1.h),
                    ),
                  ),
                  child: TextWidget(
                    widget.title,
                    textColor: AppColors.whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.child == null
                    ? _popUp()
                    : Expanded(
                        child: _popUp(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _popUp() => Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextWidget(
              widget.subTitle ?? "",
              textColor: AppColors.blackColor,
              fontSize: 16.sp,
              maxLines: 5,
              fontWeight: FontWeight.bold,
            ),
            if (widget.child != null) Expanded(child: widget.child!),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Row(
                mainAxisAlignment:
                    (widget.showSecondButton ?? true) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: widget.showSecondButton ?? true,
                    child: ButtonWidget(
                      hintText: widget.firstButtonText ?? "NÃO",
                      heightButton: 5.h,
                      widthButton: 32.w,
                      fontWeight: FontWeight.bold,
                      backgroundColor: AppColors.whiteColor,
                      borderColor: AppColors.defaultColor,
                      textColor: AppColors.defaultColor,
                      onPressed: () {
                        widget.firstButton();
                        Get.back();
                      },
                    ),
                  ),
                  ButtonWidget(
                    hintText: widget.secondButtonText ?? "SIM",
                    heightButton: 5.h,
                    widthButton: 32.w,
                    fontWeight: FontWeight.bold,
                    onPressed: () {
                      widget.secondButton();
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
