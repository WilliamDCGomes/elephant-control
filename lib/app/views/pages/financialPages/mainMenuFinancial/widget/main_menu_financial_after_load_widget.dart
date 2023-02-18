import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/app_close_controller.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../administratorPages/financialHistoryAdministrator/page/financial_history_administrator_page.dart';
import '../../../administratorPages/mainMenuAdministrator/widgets/menu_options_widget.dart';
import '../../../sharedPages/userProfile/page/user_profile_page.dart';
import '../../../widgetsShared/profile_picture_widget.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../receivePouchFromOperator/page/receive_pouch_from_operator_page.dart';
import '../../registerPouch/page/register_pouch_page.dart';
import '../controller/main_menu_financial_controller.dart';

class MainMenuFinancialAfterLoadWidget extends StatefulWidget {
  const MainMenuFinancialAfterLoadWidget({Key? key}) : super(key: key);

  @override
  State<MainMenuFinancialAfterLoadWidget> createState() => _MainMenuFinancialAfterLoadWidgetState();
}

class _MainMenuFinancialAfterLoadWidgetState extends State<MainMenuFinancialAfterLoadWidget> {
  late MainMenuFinancialController controller;

  @override
  void initState() {
    controller = Get.find(tag: "main_menu_financial_controller");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        controller.activeStep = 0;
      });
    });
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
                Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.h)),
                    color: AppColors.defaultColor,
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async => await controller.loadScreen(),
                  child: Scaffold(
                    backgroundColor: AppColors.transparentColor,
                    body: Padding(
                      padding: EdgeInsets.only(
                        top: 2.h,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            height: 8.h,
                            margin: EdgeInsets.symmetric(horizontal: 2.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButtonWidget(
                                  onTap: () => Get.to(() => UserProfilePage(
                                    mainMenuFinancialController: controller,
                                  )),
                                  borderRadius: 1.h,
                                  componentPadding: EdgeInsets.zero,
                                  widgetCustom: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 3.w),
                                        child: Container(
                                          height: 6.5.h,
                                          width: 6.5.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3.25.h),
                                          ),
                                          child: Center(
                                            child: ProfilePictureWidget(
                                              fontSize: 18.sp,
                                              hasPicture: controller.hasPicture,
                                              loadingPicture: controller.loadingPicture,
                                              profileImagePath: controller.profileImagePath,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              "Olá, ${controller.nameProfile}",
                                              textColor: AppColors.backgroundColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                              textAlign: TextAlign.start,
                                            ),
                                            TextWidget(
                                              controller.welcomePhrase.value,
                                              textColor: AppColors.backgroundColor,
                                              fontSize: 17.sp,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
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
                              Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Center(
                                  child: TextWidget(
                                    "CENTRAL TESOURARIA",
                                    textColor: AppColors.backgroundColor,
                                    fontSize: 22.sp,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Center(
                                child: Obx(
                                  () => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.h, bottom: 1.h),
                                        child: CarouselSlider.builder(
                                          carouselController: controller.carouselController,
                                          itemCount: controller.cardMainMenuAdministratorList.length,
                                          options: CarouselOptions(
                                              viewportFraction: 1,
                                              height: 31.h,
                                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                                              enlargeCenterPage: true,
                                              enableInfiniteScroll: false,
                                              onPageChanged: (itemIndex, reason) {
                                                setState(() {
                                                  controller.activeStep = itemIndex;
                                                });
                                              }),
                                          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                                            return controller.cardMainMenuAdministratorList[itemIndex];
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 1.h),
                                        child: DotStepper(
                                          dotCount: controller.cardMainMenuAdministratorList.length > 1
                                              ? controller.cardMainMenuAdministratorList.length
                                              : 2,
                                          dotRadius: 1.h,
                                          activeStep: controller.activeStep,
                                          shape: Shape.stadium,
                                          spacing: 3.w,
                                          indicator: Indicator.magnify,
                                          fixedDotDecoration: FixedDotDecoration(
                                            color: AppColors.grayStepColor,
                                          ),
                                          indicatorDecoration: IndicatorDecoration(
                                            color: AppColors.defaultColor,
                                          ),
                                          onDotTapped: (tappedDotIndex) {
                                            setState(() {
                                              controller.activeStep = tappedDotIndex;
                                              controller.carouselController.jumpToPage(tappedDotIndex);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                            child: GridView(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 1.h,
                              ),
                              padding: EdgeInsets.all(2.h),
                              children: [
                                MenuOptionsWidget(
                                  text: "Receber Malotes",
                                  imagePath: Paths.Malote,
                                  onTap: () => Get.to(() => ReceivePouchFromOperator()),
                                ),
                                MenuOptionsWidget(
                                  text: "Lançar Malotes",
                                  imagePath: Paths.Money,
                                  onTap: () => Get.to(() => RegisterPouchPage()),
                                ),
                                MenuOptionsWidget(
                                  text: "Histórico do Cofre",
                                  imagePath: Paths.Cofre,
                                  onTap: () => Get.to(() => FinancialHistoryAdministratorPage(
                                    disableSearch: true,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
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