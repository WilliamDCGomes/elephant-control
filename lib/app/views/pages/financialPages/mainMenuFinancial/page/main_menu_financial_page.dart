import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/app_close_controller.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../sharedPages/userProfile/page/user_profile_page.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/profile_picture_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../financialHistory/page/financial_history_page.dart';
import '../../receivePouchFromOperator/page/receive_pouch_from_operator_page.dart';
import '../../registerPouch/page/register_pouch_page.dart';
import '../controller/main_menu_financial_controller.dart';

class MainMenuFinancialPage extends StatefulWidget {
  const MainMenuFinancialPage({Key? key}) : super(key: key);

  @override
  State<MainMenuFinancialPage> createState() => _MainMenuFinancialPageState();
}

class _MainMenuFinancialPageState extends State<MainMenuFinancialPage> {
  late MainMenuFinancialController controller;

  @override
  void initState() {
    controller = Get.put(MainMenuFinancialController(), tag: "main_menu_financial_controller");
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
                    padding: EdgeInsets.only(top: 2.h,),
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
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.h,),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                InformationContainerWidget(
                                  iconPath: Paths.Money,
                                  textColor: AppColors.whiteColor,
                                  backgroundColor: AppColors.defaultColor,
                                  informationText: "",
                                  iconInLeft: true,
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h,),
                                  customContainer: SizedBox(
                                    width: 73.w,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: .5.h, bottom: 1.h),
                                          child: Obx(
                                            () => RichTextTwoDifferentWidget(
                                              firstText: "Quantidade no Cofre: ",
                                              firstTextColor: AppColors.whiteColor,
                                              firstTextFontWeight: FontWeight.normal,
                                              firstTextSize: 18.sp,
                                              secondText: FormatNumbers.numbersToMoney(controller.safeBoxAmount.value),
                                              secondTextColor: AppColors.whiteColor,
                                              secondTextFontWeight: FontWeight.bold,
                                              secondTextSize: 20.sp,
                                              secondTextDecoration: TextDecoration.none,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        TextWidget(
                                          "Última Atualização: ${DateFormatToBrazil.formatDateAndHour(controller.pouchLastChange)}",
                                          maxLines: 1,
                                          textColor: AppColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        InkWell(
                                          onTap: () => Get.to(() => FinancialHistoryPage(
                                            title: "Histórico do Cofre",
                                            pageTitle: "Cofre",
                                            pouchHistory: false,
                                            safeBoxAmount: controller.safeBoxAmount.value,
                                          )),
                                          child: TextWidget(
                                            "Clique aqui para ver o histórico do cofre!",
                                            maxLines: 1,
                                            textColor: AppColors.whiteColor,
                                            fontSize: 16.sp,
                                            textAlign: TextAlign.center,
                                            textDecoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InformationContainerWidget(
                                  iconPath: Paths.Malote,
                                  textColor: AppColors.whiteColor,
                                  backgroundColor: AppColors.defaultColor,
                                  informationText: "",
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h,),
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
                                                "Quantidade de Malotes:",
                                                textColor: AppColors.whiteColor,
                                                fontSize: 18.sp,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 1.w),
                                                child: Obx(
                                                      () => TextWidget(
                                                    controller.pouchQuantity.value.toString(),
                                                    fontWeight: FontWeight.bold,
                                                    maxLines: 2,
                                                    textColor: AppColors.whiteColor,
                                                    fontSize: 20.sp,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextWidget(
                                          "Última Atualização: ${DateFormatToBrazil.formatDateAndHour(controller.pouchLastChange)}",
                                          maxLines: 1,
                                          textColor: AppColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        InkWell(
                                          onTap: () => Get.to(() => FinancialHistoryPage(
                                            title: "Histórico de Malotes",
                                            pageTitle: "Malotes",
                                            pouchHistory: true,
                                          )),
                                          child: TextWidget(
                                            "Clique aqui para ver o histórico de malotes!",
                                            maxLines: 1,
                                            textColor: AppColors.whiteColor,
                                            fontSize: 16.sp,
                                            textAlign: TextAlign.center,
                                            textDecoration: TextDecoration.underline,
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
                          Paths.Malote,
                          height: 3.h,
                          color: AppColors.whiteColor,
                        ),
                        label: TextWidget(
                          "Receber Malotes do Operador",
                          maxLines: 1,
                          textColor: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => Get.to(() => ReceivePouchFromOperator()),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: FloatingActionButton.extended(
                          heroTag: "secondFloatingActionButton",
                          backgroundColor: AppColors.defaultColor,
                          foregroundColor: AppColors.backgroundColor,
                          elevation: 3,
                          icon: Image.asset(
                            Paths.Cofre,
                            height: 3.h,
                            color: AppColors.whiteColor,
                          ),
                          label: TextWidget(
                            "Lançar Malotes no Sistema",
                            maxLines: 1,
                            textColor: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () => Get.to(() => RegisterPouchPage()),
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
