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
import '../controller/forgot_information_controller.dart';

class ForgotInformationPage extends StatefulWidget {
  const ForgotInformationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotInformationPage> createState() => _ForgotInformationPageState();
}

class _ForgotInformationPageState extends State<ForgotInformationPage> {
  late ForgotInformationController controller;

  @override
  void initState() {
    controller = Get.put(ForgotInformationController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.backgroundGradientColor,
              ),
            ),
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColors.transparentColor,
                  body: Padding(
                    padding: EdgeInsets.only(top: 2.h,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.h,),
                          child: TitleWithBackButtonTabletPhoneWidget(
                            title: "Esqueceu a Senha",
                          ),
                        ),
                        InformationContainerWidget(
                          iconPath: Paths.Icone_Exibicao_Esqueci_Senha,
                          textColor: AppColors.whiteColor,
                          backgroundColor: AppColors.defaultColor,
                          informationText: "Informe o seu E-mail para recuperar a sua Senha",
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.h,),
                                  child: Form(
                                    key: controller.formKey,
                                    child: Obx(
                                      () => TextFieldWidget(
                                        controller: controller.emailInputController,
                                        hintText: "Informe o E-mail",
                                        height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                        width: double.infinity,
                                        keyboardType: TextInputType.emailAddress,
                                        enableSuggestions: true,
                                        hasError: controller.emailInputHasError.value,
                                        validator: (String? value) {
                                          String? validation = TextFieldValidators.emailValidation(value);
                                          if(validation != null && validation != ""){
                                            controller.emailInputHasError.value = true;
                                          }
                                          else{
                                            controller.emailInputHasError.value = false;
                                          }
                                          return validation;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2.h, right: 2.h, bottom: 2.h,),
                                child: ButtonWidget(
                                  hintText: "ENVIAR",
                                  fontWeight: FontWeight.bold,
                                  widthButton: 90.w,
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    controller.sendButtonPressed();
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
                controller.loadingWithSuccessOrErrorWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
