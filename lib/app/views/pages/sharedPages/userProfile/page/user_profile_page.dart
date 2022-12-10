import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../../stylePages/masks_for_text_fields.dart';
import '../../../operatorPages/mainMenu/controller/main_menu_controller.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/dropdown_button_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/profile_picture_widget.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/user_profile_controller.dart';

class UserProfilePage extends StatefulWidget {
  late final MainMenuController mainMenuController;

  UserProfilePage({
    Key? key,
    required this.mainMenuController,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with SingleTickerProviderStateMixin {
  late UserProfileController controller;

  @override
  void initState() {
    controller = Get.put(UserProfileController(), tag: 'user_profile_controller');
    controller.tabController = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    if(controller.imageChanged) {
      widget.mainMenuController.refreshProfilePicture();
    }
    super.dispose();
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
                    padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 0),
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
                              Image.asset(
                                Paths.Logo_Branca,
                                width: 30.w,
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
                                  if(controller.profileImagePath.value.isNotEmpty){
                                    showImageViewer(
                                      context,
                                      Image.network(controller.profileImagePath.value).image,
                                    );
                                  }
                                },
                                componentPadding: EdgeInsets.zero,
                                borderRadius: 6.h,
                                widgetCustom: ProfilePictureWidget(
                                  hasPicture: controller.hasPicture,
                                  loadingPicture: controller.loadingPicture,
                                  profileImagePath: controller.profileImagePath,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Obx(
                                  () => Visibility(
                                    visible: !controller.loadingPicture.value,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 1.h),
                                      child: TextButtonWidget(
                                        onTap: () => showDialog(
                                          context: Get.context!,
                                          builder: (BuildContext context) {
                                            return ConfirmationPopup(
                                              title: "Escolha uma das opções",
                                              subTitle: "Deseja alterar ou apagar a foto de perfil?",
                                              showSecondButton: controller.profileImagePath.value.isNotEmpty,
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
                            "Operador",
                            textColor: AppColors.backgroundColor,
                            fontSize: 17.sp,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => Padding(
                              padding: EdgeInsets.symmetric(horizontal: .5.w),
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.h),
                                    child: TextFieldWidget(
                                      controller: controller.nameTextController,
                                      hintText: "Nome",
                                      textCapitalization: TextCapitalization.words,
                                      height: 9.h,
                                      width: double.infinity,
                                      keyboardType: TextInputType.name,
                                      enableSuggestions: true,
                                      justRead: controller.profileIsDisabled.value,
                                      textInputAction: TextInputAction.next,
                                      hasError: controller.nameInputHasError.value,
                                      onEditingComplete: (){
                                        controller.birthDateFocusNode.requestFocus();
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h),
                                    child: TextFieldWidget(
                                      focusNode: controller.birthDateFocusNode,
                                      controller: controller.birthDateTextController,
                                      hintText: "Data de Nascimento",
                                      height: 9.h,
                                      width: double.infinity,
                                      justRead: controller.profileIsDisabled.value,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      maskTextInputFormatter: [MasksForTextFields.birthDateMask],
                                      hasError: controller.birthdayInputHasError.value,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h, bottom: 1.5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonWidget(
                                            itemSelected: controller.genderSelected.value == "" ? null : controller.genderSelected.value,
                                            hintText: "Sexo",
                                            justRead: controller.profileIsDisabled.value,
                                            height:  6.5.h,
                                            width: 90.w,
                                            listItems: controller.genderList,
                                            onChanged: (selectedState) {
                                              controller.genderSelected.value = selectedState ?? "";
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3.h),
                                    child: TextFieldWidget(
                                      controller: controller.cpfTextController,
                                      hintText: "CPF",
                                      height: 9.h,
                                      width: double.infinity,
                                      keyboardType: TextInputType.number,
                                      maskTextInputFormatter: [MasksForTextFields.cpfMask],
                                      justRead: true,
                                    ),
                                  ),
                                ],
                              ),
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
                              onPressed: () => controller.editButtonPressed(),
                            ),
                          ),
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
