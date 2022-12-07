import 'package:elephant_control/app/utils/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../../stylePages/masks_for_text_fields.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';
import '../../../widgetsShared/dropdown_button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/maintenance_controller.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({Key? key}) : super(key: key);

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  late MaintenanceController controller;

  @override
  void initState() {
    controller = Get.put(MaintenanceController());
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
                          title: "Novo Atendimento",
                          titleColor: AppColors.backgroundColor,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => InformationContainerWidget(
                                iconPath: Paths.Pelucia,
                                textColor: AppColors.whiteColor,
                                backgroundColor: AppColors.defaultColor,
                                informationText: "",
                                customContainer: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      "Máquina visitada: ${controller.requestTitle.value}",
                                      textColor: AppColors.whiteColor,
                                      fontSize: 18.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                      child: RichTextTwoDifferentWidget(
                                        firstText: "Urgência do Atendimento: ",
                                        firstTextColor: AppColors.whiteColor,
                                        firstTextFontWeight: FontWeight.normal,
                                        firstTextSize: 16.sp,
                                        secondText: controller.priority.value,
                                        secondTextColor: Color(controller.priorityColor.value),
                                        secondTextFontWeight: FontWeight.bold,
                                        secondTextSize: 16.sp,
                                        secondTextDecoration: TextDecoration.none,
                                      ),
                                    ),
                                    RichTextTwoDifferentWidget(
                                      firstText: "Data do Último Atendimento: ",
                                      firstTextColor: AppColors.whiteColor,
                                      firstTextFontWeight: FontWeight.normal,
                                      firstTextSize: 16.sp,
                                      secondText: controller.lastMaintenance.value,
                                      secondTextColor: AppColors.whiteColor,
                                      secondTextFontWeight: FontWeight.bold,
                                      secondTextSize: 16.sp,
                                      secondTextDecoration: TextDecoration.none,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
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
                                    padding: EdgeInsets.only(top: 3.h,),
                                    child: TextFieldWidget(
                                      controller: controller.operatorName,
                                      hintText: "Nome Operador",
                                      height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                      keyboardType: TextInputType.name,
                                      enableSuggestions: true,
                                      justRead: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h,),
                                    child: TextFieldWidget(
                                      controller: controller.maintenanceDate,
                                      hintText: "Data do Atendimento",
                                      height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                      keyboardType: TextInputType.number,
                                      maskTextInputFormatter: [MasksForTextFields.birthDateMask],
                                      justRead: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: .5.h, bottom: 1.h),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextWidget(
                                        "Máquina visitada",
                                        textColor: AppColors.defaultColor,
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => DropdownButtonWidget(
                                      itemSelected: controller.machineSelected.value == "" ? null : controller.machineSelected.value,
                                      hintText: "Máquina Atendida",
                                      height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                      width: 85.w,
                                      rxListItems: controller.machinesPlaces,
                                      onChanged: (selectedState) => controller.onDropdownButtonWidgetChanged(selectedState),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3.5.h,),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 1.h),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: TextWidget(
                                                    "Foto Pré Atendimento",
                                                    textColor: AppColors.defaultColor,
                                                    fontSize: 16.sp,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              controller.beforeMaintenanceImageClock,
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 1.h),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: TextWidget(
                                                    "Foto Pós Atendimento",
                                                    textColor: AppColors.defaultColor,
                                                    fontSize: 16.sp,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              controller.afterMaintenanceImageClock,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3.h,),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 1.h),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: TextWidget(
                                                    "Foto Relógio 1",
                                                    textColor: AppColors.defaultColor,
                                                    fontSize: 16.sp,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              controller.firstImageClock,
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 1.h),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: TextWidget(
                                                    "Foto Relógio 1",
                                                    textColor: AppColors.defaultColor,
                                                    fontSize: 16.sp,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              controller.secondImageClock,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3.h,),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: controller.clock1,
                                            hintText: "Relógio 1",
                                            height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                            keyboardType: TextInputType.number,
                                            maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: controller.clock2,
                                            hintText: "Relógio 2",
                                            height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                            keyboardType: TextInputType.number,
                                            maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h,),
                                    child: TextFieldWidget(
                                      controller: controller.teddyAddMachine,
                                      hintText: "Pelúcias Recolocadas na Máquina",
                                      height: PlatformType.isTablet(context) ? 7.h : 9.h,
                                      keyboardType: TextInputType.number,
                                      maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextWidget(
                                          "Malote Retirado da Máquina?",
                                          textColor: AppColors.defaultColor,
                                          fontSize: 16.sp,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: Obx(
                                          () => CheckboxListTileWidget(
                                            radioText: "Sim",
                                            size: 4.h,
                                            checked: controller.yes.value,
                                            onChanged: (){
                                              controller.yes.value = !controller.yes.value;
                                              controller.no.value = !controller.yes.value;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Expanded(
                                        child: Obx(
                                          () => CheckboxListTileWidget(
                                            radioText: "Não",
                                            size: 4.h,
                                            spaceBetween: 1.w,
                                            checked: controller.no.value,
                                            onChanged: (){
                                              controller.no.value = !controller.no.value;
                                              controller.yes.value = !controller.no.value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h, bottom: 3.h,),
                                    child: TextFieldWidget(
                                      controller: controller.observations,
                                      height: PlatformType.isTablet(context) ? 18.h : 19.h,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      textAlignVertical: TextAlignVertical.top,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        label: TextWidget(
                                          "Observação",
                                          fontSize: 16.sp,
                                          textColor: AppColors.defaultColor,
                                        ),
                                        alignLabelWithHint: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppColors.defaultColor,
                                            width: .25.h,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppColors.defaultColor,
                                            width: .25.h,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppColors.defaultColor,
                                            width: .25.h,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(1.5.h),
                                      ),
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
                                onPressed: () => controller.saveMaintenance(),
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