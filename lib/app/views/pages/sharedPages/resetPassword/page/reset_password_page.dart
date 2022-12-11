import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../../utils/text_field_validators.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/reset_password_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late ResetPasswordController controller;

  @override
  void initState() {
    controller = Get.put(ResetPasswordController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.transparentColor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.backgroundFirstScreenColor,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: TitleWithBackButtonWidget(
                          title: "Redefinir Senha",
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InformationContainerWidget(
                                iconPath: Paths.Icone_Redefinir_Senha,
                                textColor: AppColors.whiteColor,
                                backgroundColor: AppColors.defaultColor,
                                informationText: "Informe sua senha atual e sua nova senha para prosseguir!",
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                child: Form(
                                  key: controller.formKey,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: Obx(
                                          () => TextFieldWidget(
                                            controller: controller.oldPasswordInput,
                                            hintText: "Senha Atual",
                                            height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                            width: double.infinity,
                                            textInputAction: TextInputAction.next,
                                            hasError: controller.oldPasswordInputHasError.value,
                                            validator: (String? value) {
                                              String? validation = TextFieldValidators.passwordValidation(value);
                                              controller.oldPasswordInputHasError.value = validation != null && validation != "";
                                              return validation;
                                            },
                                            onEditingComplete: (){
                                              controller.newPasswordFocusNode.requestFocus();
                                            },
                                            isPassword: controller.oldPasswordVisible.value,
                                            iconTextField: GestureDetector(
                                              onTap: () {
                                                controller.oldPasswordVisible.value =
                                                !controller.oldPasswordVisible.value;
                                              },
                                              child: Icon(
                                                controller.oldPasswordVisible.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: AppColors.defaultColor,
                                                size: 2.5.h,
                                              ),
                                            ),
                                            keyboardType: TextInputType.visiblePassword,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.5.h),
                                        child: Obx(
                                          () => TextFieldWidget(
                                            controller: controller.newPasswordInput,
                                            focusNode: controller.newPasswordFocusNode,
                                            hintText: "Nova Senha",
                                            height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                            width: double.infinity,
                                            textInputAction: TextInputAction.next,
                                            hasError: controller.newPasswordInputHasError.value,
                                            validator: (String? value) {
                                              String? validation = TextFieldValidators.passwordValidation(value);
                                              if(validation != null && validation != ""){
                                                controller.newPasswordInputHasError.value = true;
                                              }
                                              else{
                                                controller.newPasswordInputHasError.value = false;
                                              }
                                              return validation;
                                            },
                                            onEditingComplete: (){
                                              controller.confirmNewPasswordFocusNode.requestFocus();
                                            },
                                            isPassword: controller.newPasswordVisible.value,
                                            iconTextField: GestureDetector(
                                              onTap: () {
                                                controller.newPasswordVisible.value =
                                                !controller.newPasswordVisible.value;
                                              },
                                              child: Icon(
                                                controller.newPasswordVisible.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: AppColors.defaultColor,
                                                size: 2.5.h,
                                              ),
                                            ),
                                            keyboardType: TextInputType.visiblePassword,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.5.h),
                                        child: Obx(
                                          () => TextFieldWidget(
                                            focusNode: controller.confirmNewPasswordFocusNode,
                                            controller: controller.confirmNewPasswordInput,
                                            hintText: "Confirme a Nova Senha",
                                            height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                            width: double.infinity,
                                            hasError: controller.confirmNewPasswordInputHasError.value,
                                            validator: (String? value) {
                                              String? validation = TextFieldValidators.confirmPasswordValidation(controller.newPasswordInput.text, value);
                                              if(validation != null && validation != ""){
                                                controller.confirmNewPasswordInputHasError.value = true;
                                              }
                                              else{
                                                controller.confirmNewPasswordInputHasError.value = false;
                                              }
                                              return validation;
                                            },
                                            isPassword: controller.confirmNewPasswordVisible.value,
                                            iconTextField: GestureDetector(
                                              onTap: () {
                                                controller.confirmNewPasswordVisible.value =
                                                !controller.confirmNewPasswordVisible.value;
                                              },
                                              child: Icon(
                                                controller.confirmNewPasswordVisible.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: AppColors.defaultColor,
                                                size: 2.5.h,
                                              ),
                                            ),
                                            keyboardType: TextInputType.visiblePassword,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.h),
                              child: ButtonWidget(
                                hintText: "REDEFINIR SENHA",
                                focusNode: controller.resetPasswordButtonFocusNode,
                                fontWeight: FontWeight.bold,
                                widthButton: double.infinity,
                                onPressed: () => controller.resetPasswordButtonPressed(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
