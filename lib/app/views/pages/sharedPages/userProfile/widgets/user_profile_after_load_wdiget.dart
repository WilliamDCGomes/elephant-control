import 'dart:io';
import 'package:elephant_control/app/views/pages/stockistPages/mainMenuStokist/controller/main_menu_stokist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import '../../../../../utils/logged_user.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../administratorPages/mainMenuAdministrator/controller/main_menu_administrator_controller.dart';
import '../../../financialPages/mainMenuFinancial/controller/main_menu_financial_controller.dart';
import '../../../operatorPages/mainMenuOperator/controller/main_menu_operator_controller.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/profile_picture_widget.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../../settingsApp/page/settings_app_page.dart';
import '../controller/user_profile_controller.dart';

class UserProfileAfterLoadWidget extends StatefulWidget {
  late final MainMenuOperatorController? mainMenuOperatorController;
  late final MainMenuFinancialController? mainMenuFinancialController;
  late final MainMenuAdministratorController? mainMenuAdministratorController;
  late final MainMenuStokistController? mainMenuStokistController;

  UserProfileAfterLoadWidget({
    Key? key,
    required this.mainMenuOperatorController,
    required this.mainMenuFinancialController,
    required this.mainMenuAdministratorController,
    required this.mainMenuStokistController,
  }) : super(key: key);

  @override
  State<UserProfileAfterLoadWidget> createState() => _UserProfileAfterLoadWidgetState();
}

class _UserProfileAfterLoadWidgetState extends State<UserProfileAfterLoadWidget> with SingleTickerProviderStateMixin {
  late UserProfileController controller;

  @override
  void initState() {
    controller = Get.find(tag: 'user_profile_controller');

    controller.tabController = TabController(
      length: 3,
      vsync: this,
    );

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
                              InkWell(
                                onTap: () => Get.to(() => SettingsAppPage()),
                                child: Icon(
                                  Icons.settings,
                                  color: AppColors.backgroundColor,
                                  size: 4.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                          width: 12.h,
                          child: Stack(
                            children: [
                              TextButtonWidget(
                                onTap: () {
                                  if(widget.mainMenuOperatorController != null ?
                                  widget.mainMenuOperatorController!.profileImagePath.value.isNotEmpty :
                                  widget.mainMenuFinancialController != null ?
                                  widget.mainMenuFinancialController!.profileImagePath.value.isNotEmpty :
                                  widget.mainMenuAdministratorController!.profileImagePath.value.isNotEmpty){
                                    showImageViewer(
                                      context,
                                      Image.memory(
                                          File(widget.mainMenuOperatorController != null ?
                                          widget.mainMenuOperatorController!.profileImagePath.value :
                                          widget.mainMenuFinancialController != null ?
                                          widget.mainMenuFinancialController!.profileImagePath.value :
                                          widget.mainMenuAdministratorController!.profileImagePath.value,
                                          ).readAsBytesSync()).image,
                                    );
                                  }
                                },
                                componentPadding: EdgeInsets.zero,
                                borderRadius: 6.h,
                                widgetCustom: widget.mainMenuOperatorController != null ?
                                ProfilePictureWidget(
                                  hasPicture: widget.mainMenuOperatorController!.hasPicture,
                                  loadingPicture: widget.mainMenuOperatorController!.loadingPicture,
                                  profileImagePath: widget.mainMenuOperatorController!.profileImagePath,
                                ) : widget.mainMenuFinancialController != null ?
                                ProfilePictureWidget(
                                  hasPicture: widget.mainMenuFinancialController!.hasPicture,
                                  loadingPicture: widget.mainMenuFinancialController!.loadingPicture,
                                  profileImagePath: widget.mainMenuFinancialController!.profileImagePath,
                                ) :
                                widget.mainMenuAdministratorController != null ?
                                ProfilePictureWidget(
                                  hasPicture: widget.mainMenuAdministratorController!.hasPicture,
                                  loadingPicture: widget.mainMenuAdministratorController!.loadingPicture,
                                  profileImagePath: widget.mainMenuAdministratorController!.profileImagePath,
                                ) :
                                ProfilePictureWidget(
                                  hasPicture: widget.mainMenuStokistController!.hasPicture,
                                  loadingPicture: widget.mainMenuStokistController!.loadingPicture,
                                  profileImagePath: widget.mainMenuStokistController!.profileImagePath,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 1.h),
                                  child: TextButtonWidget(
                                    onTap: () => showDialog(
                                      context: Get.context!,
                                      builder: (BuildContext context) {
                                        return ConfirmationPopup(
                                          title: "Escolha uma das opções",
                                          subTitle: "Deseja alterar ou apagar a foto de perfil?",
                                          showSecondButton: widget.mainMenuOperatorController != null ?
                                          widget.mainMenuOperatorController!.profileImagePath.value.isNotEmpty :
                                          widget.mainMenuFinancialController != null ?
                                          widget.mainMenuFinancialController!.profileImagePath.value.isNotEmpty :
                                          widget.mainMenuAdministratorController!.profileImagePath.value.isNotEmpty,
                                          firstButtonText: "APAGAR",
                                          secondButtonText: "ALTERAR",
                                          firstButton: () {
                                            controller.confirmationDeleteProfilePicture();
                                          },
                                          secondButton: () {
                                            controller.editProfilePicture();
                                          },
                                        );
                                      },
                                    ),
                                    height: 3.h,
                                    width: 3.h,
                                    componentPadding: EdgeInsets.zero,
                                    borderRadius: 1.h,
                                    widgetCustom: Center(
                                      child: Container(
                                        height: 3.h,
                                        width: 3.h,
                                        padding: EdgeInsets.all(.2.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(1.h),
                                          color: AppColors.black40TransparentColor,
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            Paths.Edit_Photo,
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.h, bottom: .5.h),
                          child: Obx(
                                () => TextWidget(
                              "Olá, ${controller.userName.value}!",
                              textColor: AppColors.backgroundColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: TextWidget(
                            LoggedUser.userTypeName,
                            textColor: AppColors.backgroundColor,
                            fontSize: 17.sp,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: TabBarView(
                              controller: controller.tabController,
                              children: controller.tabsList,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Obx(
                                () => ButtonWidget(
                              hintText: controller.buttonText.value,
                              fontWeight: FontWeight.bold,
                              widthButton: double.infinity,
                              borderColor: AppColors.defaultColor,
                              backgroundColor: AppColors.defaultColor,
                              onPressed: () async => await controller.editButtonPressed(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: Container(
                    height: 9.h,
                    padding: EdgeInsets.fromLTRB(.5.h, 0, .5.h, .5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4.5.h),
                        topLeft: Radius.circular(4.5.h),
                      ),
                      color: AppColors.backgroundColor,
                    ),
                    child: TabBar(
                      controller: controller.tabController,
                      indicatorColor: AppColors.defaultColor,
                      indicatorWeight: .3.h,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                      labelColor: AppColors.defaultColor,
                      unselectedLabelColor: AppColors.grayTextColor,
                      tabs: [
                        Tab(
                          text: "Perfil",
                          icon: ImageIcon(
                            AssetImage(Paths.Icone_Perfil),
                            size: 4.h,
                          ),
                          height: 9.h,
                        ),
                        Tab(
                          text: "Endereço",
                          icon: ImageIcon(
                            AssetImage(Paths.Icone_Endereco),
                            size: 4.h,
                          ),
                          height: 9.h,
                        ),
                        Tab(
                          text: "Contato",
                          icon: ImageIcon(
                            AssetImage(Paths.Icone_Contato),
                            size: 4.h,
                          ),
                          height: 9.h,
                        ),
                      ],
                    ),
                  ),
                ),
                controller.loadingWithSuccessOrErrorWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}