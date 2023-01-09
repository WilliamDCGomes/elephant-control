import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:im_stepper/stepper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/app_close_controller.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_widget.dart';
import '../controller/main_menu_administrator_controller.dart';

class MainMenuAdministratorShimmer extends StatefulWidget {
  const MainMenuAdministratorShimmer({Key? key}) : super(key: key);

  @override
  State<MainMenuAdministratorShimmer> createState() => _MainMenuAdministratorShimmerState();
}

class _MainMenuAdministratorShimmerState extends State<MainMenuAdministratorShimmer> {
  late MainMenuAdministratorController controller;

  @override
  void initState() {
    controller = Get.find(tag: "main_menu_administrator_controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return AppCloseController.verifyCloseScreen();
      },
      child: SafeArea(
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
                Column(
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
                    Stack(
                      children: [
                        Container(
                          height: 20.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.h)),
                            color: AppColors.defaultColor,
                          ),
                        ),
                        Center(
                          child: Obx(
                            () => Shimmer.fromColors(
                              baseColor: AppColors.shimmerColor,
                              highlightColor: AppColors.grayColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.h, bottom: 1.h),
                                    child: CarouselSlider.builder(
                                      carouselController: controller.carouselController,
                                      itemCount: controller.cardMainMenuAdministratorList.length,
                                      options: CarouselOptions(
                                        viewportFraction: 1,
                                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                                        enlargeCenterPage: true,
                                        enableInfiniteScroll: false,
                                      ),
                                      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                                        return controller.cardMainMenuAdministratorList[itemIndex];
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 1.h),
                                    child: DotStepper(
                                      dotCount: 2,
                                      dotRadius: 1.h,
                                      activeStep: controller.activeStep,
                                      shape: Shape.stadium,
                                      spacing: 3.w,
                                      indicator: Indicator.magnify,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: AppColors.shimmerColor,
                        highlightColor: AppColors.grayColor,
                        child: GridView(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 1.h,
                          ),
                          padding: EdgeInsets.all(2.h),
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 2.w, bottom: 1.h),
                              height: 12.h,
                              width: 12.h,
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(2.5.h),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: TextWidget(
                      "CENTRAL ADMINISTRATIVA",
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
      ),
    );
  }
}