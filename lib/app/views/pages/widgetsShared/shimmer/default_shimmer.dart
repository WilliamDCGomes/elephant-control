import 'package:elephant_control/app/utils/paths.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../stylePages/app_colors.dart';
import '../information_container_widget.dart';
import '../title_with_back_button_widget.dart';

class DefaultShimmer extends StatelessWidget {
  final String pageTitle;
  final bool showSecondFilterFild;
  final bool showButton;
  final double? mainCardSize;
  final double? cardsSize;

  const DefaultShimmer({
    Key? key,
    required this.pageTitle,
    this.showSecondFilterFild = false,
    this.showButton = false,
    this.mainCardSize,
    this.cardsSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.backgroundFirstScreenColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 8.h,
                color: AppColors.defaultColor,
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: TitleWithBackButtonWidget(
                  title: pageTitle,
                ),
              ),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: AppColors.shimmerColor,
                  highlightColor: AppColors.grayColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InformationContainerWidget(
                        iconPath: Paths.Cofre,
                        textColor: AppColors.whiteColor,
                        backgroundColor: AppColors.defaultColor,
                        informationText: "",
                        customContainer: SizedBox(
                          height: mainCardSize ?? 12.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.h, top: 1.h, right: 2.h, bottom: 3.h),
                        child: Container(
                          height: 6.5.h,
                          width: 90.w,
                          color: AppColors.blackColor,
                        ),
                      ),
                      Visibility(
                        visible: showSecondFilterFild,
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.h, right: 2.h, bottom: 3.h),
                          child: Container(
                            height: 6.5.h,
                            width: 90.w,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2.h, right: 2.h, bottom: 2.h),
                              child: Container(
                                height: cardsSize ?? 15.h,
                                width: 90.w,
                                color: AppColors.blackColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.h, right: 2.h, bottom: 2.h),
                              child: Container(
                                height: cardsSize ?? 15.h,
                                width: 90.w,
                                color: AppColors.blackColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.h, right: 2.h, bottom: 2.h),
                              child: Container(
                                height: cardsSize ?? 15.h,
                                width: 90.w,
                                color: AppColors.blackColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.h, right: 2.h, bottom: 2.h),
                              child: Container(
                                height: cardsSize ?? 15.h,
                                width: 90.w,
                                color: AppColors.blackColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 2.h, right: 2.h, bottom: 2.h),
                              child: Container(
                                height: cardsSize ?? 15.h,
                                width: 90.w,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: showButton,
                        child: Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Container(
                            height: 6.h,
                            width: 90.w,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}