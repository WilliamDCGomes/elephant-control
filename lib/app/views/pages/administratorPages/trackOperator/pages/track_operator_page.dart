import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../utils/masks_for_text_fields.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/track_operator_controller.dart';

class TrackOperatorPage extends StatefulWidget {
  final User operator;

  const TrackOperatorPage({
    Key? key,
    required this.operator,
  }) : super(key: key);

  @override
  State<TrackOperatorPage> createState() => _TrackOperatorPageState();
}

class _TrackOperatorPageState extends State<TrackOperatorPage> {
  late TrackOperatorController controller;

  @override
  void initState() {
    controller = Get.put(
      TrackOperatorController(widget.operator),
      tag: "track-operator-controller",
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
                          title: "Localização do Operador",
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Localizacao,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    "As últimas localizações recebidas do operador.",
                                    textColor: AppColors.whiteColor,
                                    fontSize: 16.sp,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 2.h,
                                top: 1.5.h,
                                right: 2.h,
                              ),
                              child: TextFieldWidget(
                                controller: controller.operatorNameTextController,
                                hintText: "Operador",
                                justRead: true,
                                height: 9.h,
                                width: double.infinity,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 2.h,
                                top: 1.5.h,
                                right: 2.h,
                              ),
                              child: TextFieldWidget(
                                controller: controller.operatorDocumentTextController,
                                hintText: "Cpf",
                                height: 9.h,
                                width: double.infinity,
                                justRead: true,
                                textInputAction: TextInputAction.next,
                                enableSuggestions: true,
                                keyboardType: TextInputType.number,
                                maskTextInputFormatter: [MasksForTextFields.cpfMask],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 2.h,
                                right: 2.h,
                                bottom: .5.h,
                              ),
                              child: TextWidget(
                                "Localizações",
                                textColor: AppColors.blackColor,
                                fontSize: 15.sp,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () => Visibility(
                                  visible: controller.userLocationList.isNotEmpty,
                                  replacement: Center(
                                    child: TextWidget(
                                      "Nenhuma localização encontrada",
                                      textColor: AppColors.blackColor,
                                    ),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                                    itemCount: controller.userLocationList.length,
                                    itemBuilder: (context, index){
                                      return Container(
                                        padding: EdgeInsets.all(2.h),
                                        margin: EdgeInsets.symmetric(vertical: 1.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.defaultColor,
                                          borderRadius: BorderRadius.circular(
                                            1.h,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.pin_drop,
                                              size: 3.h,
                                              color: AppColors.whiteColor,
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget(
                                                    controller.userLocationList[index].streetName,
                                                    textColor: AppColors.whiteColor,
                                                    fontSize: 16.sp,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  TextWidget(
                                                    controller.userLocationList[index].districtName,
                                                    textColor: AppColors.whiteColor,
                                                    fontSize: 16.sp,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  TextWidget(
                                                    controller.userLocationList[index].cityStateName,
                                                    textColor: AppColors.whiteColor,
                                                    fontSize: 16.sp,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  TextWidget(
                                                    controller.userLocationList[index].dateRegisterName,
                                                    textColor: AppColors.whiteColor,
                                                    fontSize: 16.sp,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 9.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: FloatingActionButton.extended(
                    backgroundColor: AppColors.defaultColor,
                    foregroundColor: AppColors.backgroundColor,
                    elevation: 3,
                    label: TextWidget(
                      "Mostrar no Mapa",
                      maxLines: 1,
                      textColor: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () => controller.openMap(),
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
