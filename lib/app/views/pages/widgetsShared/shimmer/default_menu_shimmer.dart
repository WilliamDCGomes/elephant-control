import 'package:elephant_control/app/utils/paths.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../stylePages/app_colors.dart';
import '../information_container_widget.dart';
import '../text_widget.dart';

class DefaultMenuShimmer extends StatelessWidget {
  final String pageTitle;
  final String firstCardIconPath;
  final String firstCardText;
  final String secondCardIconPath;
  final String secondCardText;

  const DefaultMenuShimmer({
    Key? key,
    required this.pageTitle,
    required this.firstCardIconPath,
    required this.firstCardText,
    required this.secondCardIconPath,
    required this.secondCardText,
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
          child: Stack(
            children: [
              Scaffold(
                body: Column(
                  children: [
                    Container(
                      color: AppColors.defaultColor,
                      padding: EdgeInsets.only(left: 2.h, top: 1.h, right: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer.fromColors(
                            baseColor: AppColors.shimmerColor,
                            highlightColor: AppColors.grayColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 3.w),
                                  child: SizedBox(
                                    height: 6.5.h,
                                    width: 6.5.h,
                                    child: CircularProgressIndicator(
                                      color: AppColors.shimmerColor,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 2.h,
                                      width: 25.w,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Container(
                                      height: 2.h,
                                      width: 35.w,
                                      color: AppColors.blackColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            Paths.Logo_Cor_Background,
                            width: 35.w,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.h)),
                        color: AppColors.defaultColor,
                      ),
                    ),
                    Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          InformationContainerWidget(
                            iconPath: firstCardIconPath,
                            textColor: AppColors.whiteColor,
                            backgroundColor: AppColors.defaultColor,
                            informationText: "",
                            iconInLeft: true,
                            padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 3.h),
                            customContainer: SizedBox(
                              width: 73.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: .5.h, bottom: 1.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                          firstCardText,
                                          textColor: AppColors.whiteColor,
                                          fontSize: 18.sp,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 1.w),
                                          child: Shimmer.fromColors(
                                            baseColor: AppColors.shimmerColor,
                                            highlightColor: AppColors.grayColor,
                                            child: Container(
                                              height: 2.h,
                                              width: 12.w,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerColor,
                                    highlightColor: AppColors.grayColor,
                                    child: Container(
                                      height: 2.h,
                                      width: 70.w,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerColor,
                                    highlightColor: AppColors.grayColor,
                                    child: Container(
                                      height: 2.h,
                                      width: 50.w,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InformationContainerWidget(
                            iconPath: secondCardIconPath,
                            textColor: AppColors.whiteColor,
                            backgroundColor: AppColors.defaultColor,
                            informationText: "",
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 4.h,
                            ),
                            customContainer: SizedBox(
                              width: 73.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: .5.h, bottom: 1.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                          secondCardText,
                                          textColor: AppColors.whiteColor,
                                          fontSize: 18.sp,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                        ),
                                        Shimmer.fromColors(
                                          baseColor: AppColors.shimmerColor,
                                          highlightColor: AppColors.grayColor,
                                          child: Container(
                                            height: 2.h,
                                            width: 12.w,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerColor,
                                    highlightColor: AppColors.grayColor,
                                    child: Container(
                                      height: 2.h,
                                      width: 50.w,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerColor,
                                    highlightColor: AppColors.grayColor,
                                    child: Container(
                                      height: 2.h,
                                      width: 50.w,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.shimmerColor,
                      highlightColor: AppColors.grayColor,
                      child: FloatingActionButton.extended(
                        heroTag: "firstFloatingActionButton",
                        backgroundColor: AppColors.defaultColor,
                        foregroundColor: AppColors.backgroundColor,
                        elevation: 3,
                        icon: Icon(
                          Icons.history,
                          size: 4.h,
                          color: AppColors.backgroundColor,
                        ),
                        label: TextWidget(
                          "Visitas",
                          maxLines: 1,
                          textColor: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.shimmerColor,
                        highlightColor: AppColors.grayColor,
                        child: FloatingActionButton.extended(
                          heroTag: "secondFloatingActionButton",
                          backgroundColor: AppColors.defaultColor,
                          foregroundColor: AppColors.backgroundColor,
                          elevation: 3,
                          icon: Icon(
                            Icons.add,
                            size: 4.5.h,
                            color: AppColors.backgroundColor,
                          ),
                          label: TextWidget(
                            "Adicionar nova visita",
                            maxLines: 1,
                            textColor: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: TextWidget(
                    pageTitle,
                    textColor: AppColors.backgroundColor,
                    fontSize: 22.sp,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
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