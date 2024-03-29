import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../utils/loading.dart';
import '../../../../../utils/masks_for_text_fields.dart';
import '../../../../../utils/paths.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/dropdown_button_rxlist_wdiget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/register_user_controller.dart';

class RegisterUsersPage extends StatefulWidget {
  final User? user;
  const RegisterUsersPage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<RegisterUsersPage> createState() => _RegisterUsersPageState();
}

class _RegisterUsersPageState extends State<RegisterUsersPage> {
  late RegisterUsersController controller;

  @override
  void initState() {
    controller = Get.put(RegisterUsersController(widget.user));
    super.initState();
  }

  bool get edit => widget.user != null;

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
                colors: AppColors.backgroundFirstScreenColor,
              ),
            ),
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColors.transparentColor,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        color: AppColors.defaultColor,
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: TitleWithBackButtonWidget(
                                title: edit ? "Editar Usuário" : "Cadastrar Usuário",
                              ),
                            ),
                            if (widget.user?.type == UserType.adminPrivileges)
                              InkWell(
                                onTap: () => controller.addRoles(),
                                child: Icon(
                                  Icons.privacy_tip_outlined,
                                  color: AppColors.whiteColor,
                                  size: 3.h,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Novo_Usuario,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: TextWidget(
                                edit ? "Editar Novo Usuário" : "Cadastrar Novo Usuário",
                                textColor: AppColors.whiteColor,
                                fontSize: 18.sp,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(2.h),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextWidget(
                                      "Preencha os dados",
                                      textColor: AppColors.blackColor,
                                      fontSize: 18.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.5.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.userNameTextController,
                                      hintText: "Nome",
                                      height: 9.h,
                                      keyboardType: TextInputType.name,
                                      textCapitalization: TextCapitalization.words,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: .5.h,
                                    ),
                                    child: Obx(
                                      () => Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButtonRxListWidget(
                                              itemSelected: controller.userTypeSelected.value == ""
                                                  ? null
                                                  : controller.userTypeSelected.value,
                                              hintText: "Tipo do Usuário",
                                              height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                              width: 40.w,
                                              rxListItems: controller.userTypeList,
                                              onChanged: (selectedState) {
                                                if (selectedState != null) {
                                                  controller.userTypeSelected.value = selectedState;
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Expanded(
                                            child: DropdownButtonRxListWidget(
                                              itemSelected: controller.userGenderSelected.value == ""
                                                  ? null
                                                  : controller.userGenderSelected.value,
                                              hintText: "Gênero",
                                              height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                              width: 40.w,
                                              rxListItems: controller.userGenderList,
                                              onChanged: (selectedState) {
                                                if (selectedState != null) {
                                                  controller.userGenderSelected.value = selectedState;
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 3.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.documentTextController,
                                      hintText: "Cpf",
                                      height: 9.h,
                                      textInputAction: TextInputAction.next,
                                      enableSuggestions: true,
                                      keyboardType: TextInputType.number,
                                      maskTextInputFormatter: [MasksForTextFields.cpfMask],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.birthDayTextController,
                                      hintText: "Data de Nascimento",
                                      height: 9.h,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      maskTextInputFormatter: [MasksForTextFields.birthDateMask],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.emailTextController,
                                      hintText: "E-mail",
                                      height: 9.h,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      enableSuggestions: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.phoneTextController,
                                      hintText: "Telefone",
                                      height: 9.h,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      maskTextInputFormatter: [MasksForTextFields.phoneNumberMask],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.cellPhoneTextController,
                                      hintText: "Celular",
                                      height: 9.h,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      maskTextInputFormatter: [MasksForTextFields.cellPhoneNumberMask],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.h,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextWidget(
                                        "Endereço",
                                        textColor: AppColors.defaultColor,
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.5.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.cepTextController,
                                      hintText: "Cep",
                                      height: 9.h,
                                      maskTextInputFormatter: [MasksForTextFields.cepMask],
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onChanged: (value) async {
                                        if (value.length == 9) {
                                          await Loading.startAndPauseLoading(
                                            () => controller.searchAddressInformation(),
                                            controller.loadingWithSuccessOrErrorWidget,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h),
                                    child: Obx(
                                      () => SizedBox(
                                        height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 2.w,
                                                bottom: PlatformType.isTablet(context) ? 1.7.h : 2.6.h,
                                              ),
                                              child: DropdownButtonRxListWidget(
                                                itemSelected:
                                                    controller.ufSelected.value == "" ? null : controller.ufSelected.value,
                                                hintText: "Uf",
                                                height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                                width: 23.w,
                                                rxListItems: controller.ufsList,
                                                onChanged: (selectedState) {
                                                  if (selectedState != null) {
                                                    controller.ufSelected.value = selectedState;
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFieldWidget(
                                                controller: controller.cityTextController,
                                                hintText: "Cidade",
                                                textCapitalization: TextCapitalization.words,
                                                height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                                keyboardType: TextInputType.name,
                                                enableSuggestions: true,
                                                textInputAction: TextInputAction.next,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: controller.streetTextController,
                                            hintText: "Logradouro",
                                            textCapitalization: TextCapitalization.words,
                                            height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                            keyboardType: TextInputType.streetAddress,
                                            enableSuggestions: true,
                                            textInputAction: TextInputAction.next,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 2.w),
                                          child: TextFieldWidget(
                                            controller: controller.houseNumberTextController,
                                            hintText: "Nº",
                                            textInputAction: TextInputAction.next,
                                            height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                            width: 20.w,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h),
                                    child: TextFieldWidget(
                                      controller: controller.neighborhoodTextController,
                                      hintText: "Bairro",
                                      textCapitalization: TextCapitalization.words,
                                      height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                      width: double.infinity,
                                      keyboardType: TextInputType.name,
                                      enableSuggestions: true,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h),
                                    child: TextFieldWidget(
                                      controller: controller.complementTextController,
                                      hintText: "Complemento",
                                      textCapitalization: TextCapitalization.sentences,
                                      height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                      width: double.infinity,
                                      keyboardType: TextInputType.text,
                                      enableSuggestions: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
                              child: ButtonWidget(
                                hintText: "SALVAR",
                                fontWeight: FontWeight.bold,
                                widthButton: 100.w,
                                onPressed: () async => await controller.saveNewUser(),
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
