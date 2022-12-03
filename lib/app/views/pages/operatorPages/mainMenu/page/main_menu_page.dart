import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/profile_picture_widget.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../controller/main_menu_controller.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  late MainMenuController controller;

  @override
  void initState() {
    controller = Get.put(MainMenuController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
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
                        onTap: () {

                        },
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
                                    textColor: AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.start,
                                  ),
                                  TextWidget(
                                    controller.welcomePhrase.value,
                                    textColor: AppColors.blackColor,
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
                        Paths.Logo,
                        width: 15.w,
                      ),
                    ],
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
                        SizedBox(
                          height: .5.h,
                        ),
                        TextWidget(
                          "Saldo de Pelúcias",
                          textColor: AppColors.whiteColor,
                          fontSize: 18.sp,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: TextWidget(
                            "250",
                            fontWeight: FontWeight.bold,
                            maxLines: 1,
                            textColor: AppColors.whiteColor,
                            fontSize: 20.sp,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 73.w,
                                child: TextWidget(
                                  "Última Atualização: 03/12/2022",
                                  maxLines: 1,
                                  textColor: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.h, top: 2.h, right: 2.h),
                    child: Container(

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
