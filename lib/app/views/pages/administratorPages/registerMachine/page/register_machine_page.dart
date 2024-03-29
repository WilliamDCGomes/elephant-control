import 'package:elephant_control/app/views/pages/widgetsShared/dropdown_button_widget.dart';
import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/loading.dart';
import '../../../../../utils/masks_for_text_fields.dart';
import '../../../../../utils/paths.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';
import '../../../widgetsShared/dropdown_button_rxlist_wdiget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/register_machine_controller.dart';

class RegisterMachinePage extends StatefulWidget {
  final Machine? machine;
  final bool edit;
  final List<int> externalIds;

  const RegisterMachinePage({
    Key? key,
    this.machine,
    this.edit = false,
    required this.externalIds,
  }) : super(key: key);

  @override
  State<RegisterMachinePage> createState() => _RegisterMachinePageState();
}

class _RegisterMachinePageState extends State<RegisterMachinePage> {
  late RegisterMachineController controller;

  @override
  void initState() {
    controller = Get.put(RegisterMachineController(widget.machine, widget.edit, widget.externalIds));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Get.back();
          return Future.value(false);
        },
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
                          child: TitleWithBackButtonWidget(
                            title: (widget.edit ? "Editar " : "Cadastrar ") + "Máquina",
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InformationContainerWidget(
                                iconPath: Paths.Maquina_Pelucia,
                                textColor: AppColors.whiteColor,
                                backgroundColor: AppColors.defaultColor,
                                informationText: "",
                                customContainer: TextWidget(
                                  (widget.edit ? "Editar " : "Cadastrar Nova ") + "Máquina",
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
                                        controller: controller.machineNameTextController,
                                        hintText: "Nome da Máquina",
                                        height: 9.h,
                                        keyboardType: TextInputType.name,
                                        textCapitalization: TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextWidget(
                                            "Fechamento de máquina aparece para operador?",
                                            textColor: AppColors.defaultColor,
                                            fontSize: 16.sp,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Obx(
                                              () => CheckboxListTileWidget(
                                                radioText: "Sim",
                                                size: 4.h,
                                                checked: controller.machineCloseYes.value,
                                                onChanged: () {
                                                  controller.machineCloseYes.value = !controller.machineCloseYes.value;
                                                  if (controller.machineCloseYes.value)
                                                    controller.machineCloseNo.value = !controller.machineCloseYes.value;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: .5.w,
                                            ),
                                            Obx(
                                              () => CheckboxListTileWidget(
                                                radioText: "Não",
                                                size: 4.h,
                                                spaceBetween: 1.w,
                                                checked: controller.machineCloseNo.value,
                                                onChanged: () {
                                                  controller.machineCloseNo.value = !controller.machineCloseNo.value;
                                                  if (controller.machineCloseNo.value)
                                                    controller.machineCloseYes.value = !controller.machineCloseNo.value;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.h,
                                      ),
                                      child: TextFieldWidget(
                                        controller: controller.machineTypeTextController,
                                        hintText: "Tipo da Máquina",
                                        height: 9.h,
                                        keyboardType: TextInputType.name,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller: controller.minAverageTextController,
                                              hintText: "Valor Mínimo",
                                              height: 9.h,
                                              keyboardType: TextInputType.number,
                                              maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                              textInputAction: TextInputAction.next,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller: controller.maxAverageTextController,
                                              hintText: "Valor Máximo",
                                              height: 9.h,
                                              keyboardType: TextInputType.number,
                                              maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                              textInputAction: TextInputAction.next,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller: controller.firstClockTextController,
                                              hintText: "Valor 1º Relógio",
                                              height: 9.h,
                                              keyboardType: TextInputType.number,
                                              maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                              textInputAction: TextInputAction.next,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller: controller.secondClockTextController,
                                              hintText: "Valor 2º Relógio",
                                              height: 9.h,
                                              keyboardType: TextInputType.number,
                                              maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                              textInputAction: TextInputAction.next,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.h,
                                      ),
                                      child: TextFieldWidget(
                                        controller: controller.periodVisitsTextController,
                                        hintText: "Período de Visitas (dias)",
                                        height: 9.h,
                                        keyboardType: TextInputType.number,
                                        maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: 2.w,
                                        // bottom: PlatformType.isTablet(context) ? 1.7.h : 2.6.h,
                                      ),
                                      child: GetBuilder<RegisterMachineController>(
                                          id: 'returnMachineViewControllerSelected',
                                          init: controller,
                                          builder: (_) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                DropdownButtonWidget(
                                                    hintText: "Selecione a máquina na VM Pay",
                                                    maxLines: 3,
                                                    height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                                    width: 23.w,
                                                    itemSelected:
                                                        controller.returnMachineViewControllerSelected?.id?.toString(),
                                                    listItems: controller.returnMachineViewControllers.map((element) =>
                                                        DropdownItem(
                                                            item: element.asset_number, value: element.id.toString())),
                                                    onChanged: (selectedState) =>
                                                        controller.onChangedRegisterMachineSelected(selectedState)),
                                                SizedBox(height: PlatformType.isTablet(context) ? 1.7.h : 2.6.h),
                                                Visibility(
                                                  visible: controller.returnMachineViewControllerSelected?.id == -1,
                                                  child: TextFieldWidget(
                                                    controller: controller.externalCodeMachineController,
                                                    hintText: "Código Externo Manual",
                                                    height: 9.h,
                                                    maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.next,
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.h,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextWidget(
                                          "Localização",
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
                                                  onChanged: (selectedState) =>
                                                      controller.onChangedUfSelected(selectedState),
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
                                  onPressed: () async => await controller.saveNewMachine(),
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
      ),
    );
  }
}
