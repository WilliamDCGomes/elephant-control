import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../utils/masks_for_text_fields.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
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
    controller = Get.put(TrackOperatorController(widget.operator));
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
                                  RichTextTwoDifferentWidget(
                                    firstText: "Última Localização Recebida: ",
                                    firstTextColor: AppColors.whiteColor,
                                    firstTextFontWeight: FontWeight.normal,
                                    firstTextSize: 16.sp,
                                    secondText: "Bauru",
                                    secondTextColor: AppColors.whiteColor,
                                    secondTextFontWeight: FontWeight.bold,
                                    secondTextSize: 16.sp,
                                    secondTextDecoration: TextDecoration.none,
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
                                      top: 1.5.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.operatorNameTextController,
                                      hintText: "Operador",
                                      justRead: true,
                                      height: 9.h,
                                      keyboardType: TextInputType.name,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.5.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.operatorDocumentTextController,
                                      hintText: "Cpf",
                                      height: 9.h,
                                      justRead: true,
                                      textInputAction: TextInputAction.next,
                                      enableSuggestions: true,
                                      keyboardType: TextInputType.number,
                                      maskTextInputFormatter: [MasksForTextFields.cpfMask],
                                    ),
                                  ),
                                ],
                              ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
