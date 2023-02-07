import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/app_close_controller.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../sharedPages/userProfile/page/user_profile_page.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/profile_picture_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../addPlushInStock/page/add_plush_in_stock_page.dart';
import '../../addRemoveOperatorBalancePlush/page/add_remove_operator_balance_plush_page.dart';
import '../controller/main_menu_stokist_controller.dart';

class MainMenuStokistAfterLoadWidget extends StatefulWidget {
  const MainMenuStokistAfterLoadWidget({Key? key}) : super(key: key);

  @override
  State<MainMenuStokistAfterLoadWidget> createState() => _MainMenuStokistAfterLoadWidgetState();
}

class _MainMenuStokistAfterLoadWidgetState extends State<MainMenuStokistAfterLoadWidget> {
  late MainMenuStokistController controller;

  @override
  void initState() {
    controller = Get.find(tag: "main_menu_stokist_controller");
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
                Scaffold(
                  backgroundColor: AppColors.transparentColor,
                  body: Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 8.h,
                          margin: EdgeInsets.symmetric(horizontal: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButtonWidget(
                                onTap: () => Get.to(() => UserProfilePage(
                                      mainMenuStokistController: controller,
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
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Center(
                            child: TextWidget(
                              "CENTRAL ESTOQUISTA",
                              textColor: AppColors.backgroundColor,
                              fontSize: 22.sp,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 8.h,
                            ),
                            child: InformationContainerWidget(
                              iconPath: Paths.Pelucia,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              iconInLeft: true,
                              isLoading: controller.isLoadingQuantity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 4.h,
                              ),
                              customContainer: SizedBox(
                                width: 73.w,
                                child: Obx(
                                  () => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: .5.h, bottom: 1.h),
                                        child: RichTextTwoDifferentWidget(
                                          firstText: "Quantidade de Pelúcias: ",
                                          firstTextColor: AppColors.whiteColor,
                                          firstTextFontWeight: FontWeight.normal,
                                          firstTextSize: 18.sp,
                                          secondText: FormatNumbers.scoreIntNumber(
                                            controller.plushQuantity.value,
                                          ),
                                          secondTextColor: AppColors.whiteColor,
                                          secondTextFontWeight: FontWeight.bold,
                                          secondTextSize: 20.sp,
                                          secondTextDecoration: TextDecoration.none,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      TextWidget(
                                        "Última Atualização: ${DateFormatToBrazil.formatDateAndHour(
                                          controller.quantityLastUpdate.value,
                                        )}",
                                        maxLines: 1,
                                        textColor: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "firstFloatingActionButton",
                        backgroundColor: AppColors.defaultColor,
                        foregroundColor: AppColors.backgroundColor,
                        elevation: 3,
                        icon: Image.asset(
                          Paths.Pelucia_Add,
                          height: 3.h,
                          color: AppColors.whiteColor,
                        ),
                        label: TextWidget(
                          "Adicionar Pelúcias ao Estoque",
                          maxLines: 1,
                          textColor: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () async {
                          await Get.to(() => AddPlushInStockPage());
                          await controller.getQuantityData();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: FloatingActionButton.extended(
                          heroTag: "secondFloatingActionButton",
                          backgroundColor: AppColors.defaultColor,
                          foregroundColor: AppColors.backgroundColor,
                          elevation: 3,
                          icon: Image.asset(
                            Paths.Pelucia_Add,
                            height: 3.h,
                            color: AppColors.whiteColor,
                          ),
                          label: TextWidget(
                            "Adicionar Pelúcias no Saldo do Operador",
                            maxLines: 1,
                            textColor: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            await Get.to(() => AddRemoveOperatorBalancePlushPage(
                              addPluch: true,
                            ));
                            await controller.getQuantityData();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: FloatingActionButton.extended(
                          heroTag: "thirdFloatingActionButton",
                          backgroundColor: AppColors.defaultColor,
                          foregroundColor: AppColors.backgroundColor,
                          elevation: 3,
                          icon: Image.asset(
                            Paths.Pelucia_Remove,
                            height: 3.h,
                            color: AppColors.whiteColor,
                          ),
                          label: TextWidget(
                            "Retirar Pelúcias do Saldo do Operador",
                            maxLines: 1,
                            textColor: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            await Get.to(() => AddRemoveOperatorBalancePlushPage(
                              addPluch: false,
                            ));
                            await controller.getQuantityData();
                          },
                        ),
                      ),
                    ],
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
