import 'dart:io';
import 'package:elephant_control/base/models/machine/machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../../utils/picture_util.dart';
import '../../../../../utils/video_player_util.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/occurrence_controller.dart';

class OccurrencePage extends StatefulWidget {
  final Machine machine;
  final String visitId;
  final IncidentObject? incident;
  final bool edit;

  const OccurrencePage({
    Key? key,
    required this.machine,
    required this.visitId,
    required this.incident,
    this.edit = true,
  }) : super(key: key);

  @override
  State<OccurrencePage> createState() => _OccurrencePageState();
}

class _OccurrencePageState extends State<OccurrencePage> {
  late OccurrenceController controller;

  @override
  void initState() {
    controller = Get.put(
      OccurrenceController(
        widget.machine,
        widget.visitId,
        widget.incident,
        widget.edit,
      ),
      //permanent: true,
    );

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
                        child: GetBuilder(
                          id: "informations",
                          init: controller,
                          builder:(_) => Column(
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
                                    Container(
                                        height: 5.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.defaultColor,
                                            width: .25.h,
                                          ),
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.all(1.h),
                                            child: TextWidget(
                                              widget.machine.name,
                                              fontSize: 16.sp,
                                              textColor: AppColors.defaultColor,
                                            ))),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 3.5.h,
                                      ),
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
                                              Visibility(
                                                visible: widget.edit,
                                                child: controller.machineOccurrencePicture,
                                                replacement: InkWell(
                                                  onTap: () => PictureUtil.openImage(
                                                    controller.machineOccurrencePicture.picture,
                                                  ),
                                                  child: IgnorePointer(
                                                    child: controller.machineOccurrencePicture,
                                                  ),
                                                ),
                                              ),
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
                                              Visibility(
                                                visible: widget.edit,
                                                child: controller.extraMachineOccurrencePicture,
                                                replacement: InkWell(
                                                  onTap: () => PictureUtil.openImage(
                                                    controller.extraMachineOccurrencePicture.picture,
                                                  ),
                                                  child: IgnorePointer(
                                                    child: controller.extraMachineOccurrencePicture,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 3.5.h,
                                      ),
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
                                          Visibility(
                                            visible: widget.edit,
                                            child: controller.machineOccurrenceVideo,
                                            replacement: InkWell(
                                              onTap: () async {
                                                if(controller.machineOccurrenceVideo.picture != null){
                                                  File? file = await controller.getVideoFile(controller.machineOccurrenceVideo.base64);
                                                  if(file != null){
                                                    await SystemChrome.setEnabledSystemUIMode(
                                                      SystemUiMode.manual,
                                                      overlays: [],
                                                    );
                                                    await Get.to(() => VideoPlayerUtil(
                                                      videoFile: file,
                                                    ));
                                                    await SystemChrome.setEnabledSystemUIMode(
                                                      SystemUiMode.manual,
                                                      overlays: SystemUiOverlay.values,
                                                    );
                                                  }
                                                }
                                              },
                                              child: IgnorePointer(
                                                child: controller.machineOccurrenceVideo,
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
