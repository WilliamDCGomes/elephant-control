import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';

class CardMainMenuAdministratorWidget extends StatefulWidget {
  final String firstText;
  final String secondText;
  final String thirdText;
  final String fourthText;
  final String? complementFirstText;
  final String? complementSecondText;
  final String? imagePath;

  const CardMainMenuAdministratorWidget({
    Key? key,
    required this.firstText,
    required this.secondText,
    this.thirdText = "",
    this.fourthText = "",
    this.imagePath,
    this.complementFirstText,
    this.complementSecondText,
  }) : super(key: key);

  @override
  State<CardMainMenuAdministratorWidget> createState() => _CardMainMenuAdministratorWidgetState();
}

class _CardMainMenuAdministratorWidgetState extends State<CardMainMenuAdministratorWidget> {
  @override
  Widget build(BuildContext context) {
    return InformationContainerWidget(
      iconPath: widget.imagePath ?? Paths.Icone_Home,
      textColor: AppColors.whiteColor,
      backgroundColor: AppColors.defaultColor,
      informationText: "",
      showBorder: true,
      padding: EdgeInsets.fromLTRB(5.w, 3.h, 20.w, 3.h),
      customContainer: SizedBox(
        height: 30.h,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.thirdText == "" || widget.fourthText == "",
                child: SizedBox(
                  height: 3.h,
                ),
              ),
              RichTextTwoDifferentWidget(
                firstText: widget.firstText,
                firstTextColor: AppColors.whiteColor,
                firstTextFontWeight: FontWeight.bold,
                firstTextSize: 20.sp,
                secondText: widget.secondText,
                secondTextColor: AppColors.whiteColor,
                secondTextFontWeight: FontWeight.normal,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
              if (widget.complementFirstText != null && widget.complementSecondText != null)
                RichTextTwoDifferentWidget(
                  firstText: widget.complementFirstText,
                  firstTextColor: AppColors.whiteColor,
                  firstTextFontWeight: FontWeight.bold,
                  firstTextSize: 20.sp,
                  secondText: widget.complementSecondText,
                  secondTextColor: AppColors.whiteColor,
                  secondTextFontWeight: FontWeight.normal,
                  secondTextSize: 18.sp,
                  secondTextDecoration: TextDecoration.none,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              Visibility(
                visible: widget.thirdText != "" && widget.fourthText != "",
                child: Divider(
                  color: AppColors.whiteColor,
                ),
              ),
              Visibility(
                visible: widget.thirdText != "" && widget.fourthText != "",
                child: RichTextTwoDifferentWidget(
                  firstText: widget.thirdText,
                  firstTextColor: AppColors.whiteColor,
                  firstTextFontWeight: FontWeight.bold,
                  firstTextSize: 20.sp,
                  secondText: widget.fourthText,
                  secondTextColor: AppColors.whiteColor,
                  secondTextFontWeight: FontWeight.normal,
                  secondTextSize: 18.sp,
                  secondTextDecoration: TextDecoration.none,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
