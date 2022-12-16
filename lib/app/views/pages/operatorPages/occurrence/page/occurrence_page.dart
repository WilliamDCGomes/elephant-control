import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/dropdown_button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/occurrence_controller.dart';

class OccurrencePage extends StatefulWidget {
  const OccurrencePage({Key? key}) : super(key: key);

  @override
  State<OccurrencePage> createState() => _OccurrencePageState();
}

class _OccurrencePageState extends State<OccurrencePage> {
  late OccurrenceController controller;

  @override
  void initState() {
    controller = Get.put(OccurrenceController());
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
                          title: "Abrir Ocorrência",
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Pelucia,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: TextWidget(
                                "Preencha as informações para abrir uma ocorrência",
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
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: .5.h, bottom: 1.h),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextWidget(
                                        "Máquina da Ocorrência",
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
                                      height: 6.5.h,
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
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 1.h),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: TextWidget(
                                                  "Foto da Máquina",
                                                  textColor: AppColors.defaultColor,
                                                  fontSize: 16.sp,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                            controller.machineOccurrencePicture,
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: 1.h),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: TextWidget(
                                                  "Foto Extra",
                                                  textColor: AppColors.defaultColor,
                                                  fontSize: 16.sp,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                            controller.extraMachineOccurrencePicture,
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3.5.h,),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 1.h),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextWidget(
                                              "Vídeo",
                                              textColor: AppColors.defaultColor,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                        controller.machineOccurrenceVideo,
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 3.5.h, bottom: 3.h,),
                                    child: TextFieldWidget(
                                      controller: controller.observations,
                                      height: 19.h,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      textAlignVertical: TextAlignVertical.top,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        label: TextWidget(
                                          "Ocorrido",
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
                                onPressed: () => controller.saveOccurrence(),
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
