import 'package:elephant_control/app/utils/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/visit_details_controller.dart';

class VisitDetailsPage extends StatefulWidget {
  final String visitId;
  final bool editPictures;

  const VisitDetailsPage({
    Key? key,
    required this.visitId,
    this.editPictures = true,
  }) : super(key: key);

  @override
  State<VisitDetailsPage> createState() => _VisitDetailsPageState();
}

class _VisitDetailsPageState extends State<VisitDetailsPage> {
  late VisitDetailsController controller;

  @override
  void initState() {
    controller = Get.put(VisitDetailsController(widget.visitId));
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TitleWithBackButtonWidget(
                                title: "Detalhes do Atendimento",
                              ),
                            ),
                            GetBuilder(
                              id: "incident",
                              init: controller,
                              builder: (_) => Visibility(
                                visible: controller.incident != null,
                                child: InkWell(
                                  onTap: () => controller.openIncident(context),
                                  child: Image.asset(
                                    Paths.Ocorrencia,
                                    color: AppColors.whiteColor,
                                    height: 3.h,
                                    width: 3.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GetBuilder(
                          init: controller,
                          id: "visit-details",
                          builder: (_) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InformationContainerWidget(
                                iconPath: Paths.Pelucia,
                                textColor: AppColors.whiteColor,
                                backgroundColor: AppColors.defaultColor,
                                informationText: "",
                                customContainer: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      "Máquina visitada: ${controller.visitViewController != null ?
                                      controller.visitViewController!.machineName : ""}",
                                      textColor: AppColors.whiteColor,
                                      fontSize: 18.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.5.h),
                                      child: RichTextTwoDifferentWidget(
                                        firstText: "Data do Atendimento: ",
                                        firstTextColor: AppColors.whiteColor,
                                        firstTextFontWeight: FontWeight.normal,
                                        firstTextSize: 16.sp,
                                        secondText: controller.maintenanceDate,
                                        secondTextColor: AppColors.whiteColor,
                                        secondTextFontWeight: FontWeight.bold,
                                        secondTextSize: 16.sp,
                                        secondTextDecoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 2.h,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 1.h),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextWidget(
                                                "Foto Inicial",
                                                textColor: AppColors.defaultColor,
                                                fontSize: 16.sp,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.editPictures,
                                            child: controller.beforeMaintenanceImageClock,
                                            replacement: InkWell(
                                              onTap: () => controller.openImage(
                                                controller.beforeMaintenanceImageClock.picture,
                                              ),
                                              child: IgnorePointer(
                                                child: controller.beforeMaintenanceImageClock,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 3.h,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 1.h),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextWidget(
                                                "Foto dos Relógios",
                                                textColor: AppColors.defaultColor,
                                                fontSize: 16.sp,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.editPictures,
                                            child: controller.imageClock,
                                            replacement: InkWell(
                                              onTap: () => controller.openImage(
                                                controller.imageClock.picture,
                                              ),
                                              child: IgnorePointer(
                                                child: controller.imageClock,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 3.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextFieldWidget(
                                              controller: controller.clock1,
                                              hintText: "Relógio Numeração",
                                              height: 9.h,
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
                                              hintText: "Relógio de Prêmios",
                                              height: 9.h,
                                              keyboardType: TextInputType.number,
                                              maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.5.h,
                                      ),
                                      child: TextFieldWidget(
                                        controller: controller.teddyAddMachine,
                                        hintText: "Reposição de Pelúcias",
                                        height: 9.h,
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
                                              onChanged: () {
                                                controller.yes.value = !controller.yes.value;
                                                if (controller.yes.value) controller.no.value = !controller.yes.value;
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: .5.w,
                                        ),
                                        Expanded(
                                          child: Obx(
                                            () => CheckboxListTileWidget(
                                              radioText: "Não",
                                              size: 4.h,
                                              spaceBetween: 1.w,
                                              checked: controller.no.value,
                                              onChanged: () {
                                                controller.no.value = !controller.no.value;
                                                if (controller.no.value) controller.yes.value = !controller.no.value;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextWidget(
                                              "Fechamento da Máquina?",
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
                                                checked: controller.machineCloseYes.value,
                                                onChanged: () {
                                                  controller.machineCloseYes.value = !controller.machineCloseYes.value;
                                                  if (controller.machineCloseYes.value) controller.machineCloseNo.value = !controller.machineCloseYes.value;
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: .5.w,
                                          ),
                                          Expanded(
                                            child: Obx(
                                              () => CheckboxListTileWidget(
                                                radioText: "Não",
                                                size: 4.h,
                                                spaceBetween: 1.w,
                                                checked: controller.machineCloseNo.value,
                                                onChanged: () {
                                                  controller.machineCloseNo.value = !controller.machineCloseNo.value;
                                                  if (controller.machineCloseNo.value) controller.machineCloseYes.value = !controller.machineCloseNo.value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 1.5.h,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 1.h),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextWidget(
                                                "Foto Final",
                                                textColor: AppColors.defaultColor,
                                                fontSize: 16.sp,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.editPictures,
                                            child: controller.afterMaintenanceImageClock,
                                            replacement: InkWell(
                                              onTap: () => controller.openImage(
                                                controller.afterMaintenanceImageClock.picture,
                                              ),
                                              child: IgnorePointer(
                                                child: controller.afterMaintenanceImageClock,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 3.5.h,
                                        bottom: 3.h,
                                      ),
                                      child: TextFieldWidget(
                                        controller: controller.observations,
                                        height: 19.h,
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
                                  hintText: "EDITAR",
                                  fontWeight: FontWeight.bold,
                                  widthButton: 100.w,
                                  onPressed: () => controller.editMaintenance(),
                                ),
                              ),
                            ],
                          ),
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