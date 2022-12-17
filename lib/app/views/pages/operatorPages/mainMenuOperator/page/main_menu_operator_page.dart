import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/app/views/pages/operatorPages/history/page/history_page.dart';
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
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../maintenance/page/maintenance_page.dart';
import '../../maintenanceHistory/pages/maintenance_history_page.dart';
import '../controller/main_menu_operator_controller.dart';

class MainMenuOperatorPage extends StatefulWidget {
  const MainMenuOperatorPage({Key? key}) : super(key: key);

  @override
  State<MainMenuOperatorPage> createState() => _MainMenuOperatorPageState();
}

class _MainMenuOperatorPageState extends State<MainMenuOperatorPage> {
  late MainMenuOperatorController controller;

  @override
  void initState() {
    controller = Get.put(MainMenuOperatorController(), tag: "main_menu_controller");
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
                                  mainMenuOperatorController: controller,
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
                              "CENTRAL ${LoggedUser.userTypeName.toUpperCase()}",
                              textColor: AppColors.backgroundColor,
                              fontSize: 22.sp,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Center(
                            child: InformationContainerWidget(
                              iconPath: Paths.Malote,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              iconInLeft: true,
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h,),
                              customContainer: ListView(
                                shrinkWrap: true,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: .5.h, bottom: 1.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextWidget(
                                          "Quantidade de Malote(s):",
                                          textColor: AppColors.whiteColor,
                                          fontSize: 18.sp,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 1.w),
                                          child: Obx(
                                            () => TextWidget(
                                              controller.amountPouch.value.toString(),
                                              fontWeight: FontWeight.bold,
                                              maxLines: 1,
                                              textColor: AppColors.whiteColor,
                                              fontSize: 20.sp,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 73.w,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
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
                                          onTap: () => Get.to(() => HistoryPage(
                                            title: "Histórico de Malotes",
                                            pageTitle: "Visitas",
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: InformationContainerWidget(
                            iconPath: Paths.Pelucia,
                            textColor: AppColors.whiteColor,
                            backgroundColor: AppColors.defaultColor,
                            informationText: "",
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h,),
                            customContainer: ListView(
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: .5.h, bottom: 1.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        "Saldo de Pelúcias:",
                                        textColor: AppColors.whiteColor,
                                        fontSize: 18.sp,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 1.w),
                                        child: Obx(
                                          () => TextWidget(
                                            controller.amountTeddy.value.toString(),
                                            fontWeight: FontWeight.bold,
                                            maxLines: 1,
                                            textColor: AppColors.whiteColor,
                                            fontSize: 20.sp,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 73.w,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextWidget(
                                        "Última Atualização: ${DateFormatToBrazil.formatDateAndHour(controller.teddyLastChange)}",
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
                                        onTap: () => Get.to(() => HistoryPage(
                                          title: "Histórico de Pelúcias",
                                          pageTitle: "Visitas",
                                        )),
                                        child: TextWidget(
                                          "Clique aqui para ver as pelúcias!",
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
                        onPressed: () => Get.to(() => MaintenanceHistoryPage()),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
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
                            "Adicionar novo atendimento",
                            maxLines: 1,
                            textColor: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () => Get.to(() => MaintenancePage()),
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