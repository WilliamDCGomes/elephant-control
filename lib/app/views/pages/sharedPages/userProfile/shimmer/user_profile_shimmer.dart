import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/user_profile_controller.dart';

class UserProfileShimmer extends StatefulWidget {
  UserProfileShimmer({Key? key}) : super(key: key);

  @override
  State<UserProfileShimmer> createState() => _UserProfileShimmerState();
}

class _UserProfileShimmerState extends State<UserProfileShimmer> with SingleTickerProviderStateMixin {
  late UserProfileController controller;

  @override
  void initState() {
    controller = Get.find(tag: 'user_profile_controller');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Material(
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.backgroundFirstScreenColor,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.h)),
                    color: AppColors.defaultColor,
                  ),
                ),
                Scaffold(
                  backgroundColor: AppColors.transparentColor,
                  body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 8.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TitleWithBackButtonWidget(
                                  title: "Perfil",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                          width: 12.h,
                          child: CircularProgressIndicator(
                            color: AppColors.shimmerColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h, bottom: .5.h),
                          child: Shimmer.fromColors(
                            baseColor: AppColors.shimmerColor,
                            highlightColor: AppColors.grayColor,
                            child: Container(
                              height: 3.h,
                              width: 25.w,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Shimmer.fromColors(
                            baseColor: AppColors.shimmerColor,
                            highlightColor: AppColors.grayColor,
                            child: Container(
                              height: 3.h,
                              width: 50.w,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Shimmer.fromColors(
                              baseColor: AppColors.shimmerColor,
                              highlightColor: AppColors.grayColor,
                              child: ListView(
                                children: [
                                  Container(
                                    height: 7.h,
                                    width: 90.w,
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    color: AppColors.blackColor,
                                  ),
                                  Container(
                                    height: 7.h,
                                    width: 90.w,
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    color: AppColors.blackColor,
                                  ),
                                  Container(
                                    height: 7.h,
                                    width: 90.w,
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    color: AppColors.blackColor,
                                  ),
                                  Container(
                                    height: 7.h,
                                    width: 90.w,
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    color: AppColors.blackColor,
                                  ),
                                  Container(
                                    height: 7.h,
                                    width: 90.w,
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    color: AppColors.blackColor,
                                  ),
                                  Container(
                                    height: 7.h,
                                    width: 90.w,
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    color: AppColors.blackColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Shimmer.fromColors(
                            baseColor: AppColors.shimmerColor,
                            highlightColor: AppColors.grayColor,
                            child: Container(
                              height: 7.h,
                              width: 98.w,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: Shimmer.fromColors(
                    baseColor: AppColors.shimmerColor,
                    highlightColor: AppColors.grayColor,
                    child: Container(
                      height: 9.h,
                      padding: EdgeInsets.fromLTRB(.5.h, 0, .5.h, .5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4.5.h),
                          topLeft: Radius.circular(4.5.h),
                        ),
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}