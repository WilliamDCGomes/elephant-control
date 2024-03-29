import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/paths.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/operators_visits_controller.dart';
import '../widgets/operator_visit_card_widget.dart';

class OperatorsVisitsAfterLoadWidget extends StatefulWidget {
  const OperatorsVisitsAfterLoadWidget({Key? key}) : super(key: key);

  @override
  State<OperatorsVisitsAfterLoadWidget> createState() => _OperatorsVisitsAfterLoadWidgetState();
}

class _OperatorsVisitsAfterLoadWidgetState extends State<OperatorsVisitsAfterLoadWidget> {
  late OperatorsVisitsController controller;

  @override
  void initState() {
    controller = Get.find(tag: "operators-visits-controller");
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 8.h,
                        color: AppColors.defaultColor,
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: Obx(
                          () => TitleWithBackButtonWidget(
                            title: "Visitas dos Operadores",
                            rightIcon: controller.showInfos.value ? Icons.visibility_off : Icons.visibility,
                            onTapRightIcon: () => controller.showInfos.value = !controller.showInfos.value,
                          ),
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: controller.showInfos.value,
                          child: InformationContainerWidget(
                            iconPath: Paths.Manutencao,
                            textColor: AppColors.whiteColor,
                            backgroundColor: AppColors.defaultColor,
                            informationText: "",
                            customContainer: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidget(
                                  "Visitas dos Operadores nas Máquinas",
                                  textColor: AppColors.whiteColor,
                                  fontSize: 18.sp,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                TextWidget(
                                  "Selecione um usuário para visualizar as visitas e a data, para filtrar pelo dia",
                                  textColor: AppColors.whiteColor,
                                  fontSize: 16.sp,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Obx(
                                  () => RichTextTwoDifferentWidget(
                                    firstText: "Quantidade de Visitas: ",
                                    firstTextColor: AppColors.whiteColor,
                                    firstTextFontWeight: FontWeight.normal,
                                    firstTextSize: 18.sp,
                                    secondText: controller.visitsQuantity.value.toString(),
                                    secondTextColor: AppColors.whiteColor,
                                    secondTextFontWeight: FontWeight.bold,
                                    secondTextSize: 18.sp,
                                    secondTextDecoration: TextDecoration.none,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.h, top: 1.h, right: 2.h, bottom: 2.h),
                        child: InkWell(
                          onTap: () async => controller.selectedUsers(),
                          child: Container(
                            height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.defaultColor,
                                width: .25.h,
                              ),
                            ),
                            padding: EdgeInsets.all(.5.h),
                            margin: EdgeInsets.only(top: 1.h),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(
                                    () => TextWidget(
                                  controller.userSelected.value,
                                  textColor: AppColors.blackColor,
                                  fontSize: 16.sp,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async => await controller.filterPerDate(),
                        child: Container(
                          height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.defaultColor,
                              width: .25.h,
                            ),
                          ),
                          padding: EdgeInsets.all(1.h),
                          margin: EdgeInsets.only(left: 2.h, top: 1.h, right: 2.h, bottom: 2.h),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GetBuilder(
                              id: "date-filter",
                              init: controller,
                              builder: (_) => RichTextTwoDifferentWidget(
                                firstText: "Data da Visita: ",
                                firstTextColor: AppColors.blackColor,
                                firstTextFontWeight: FontWeight.normal,
                                firstTextSize: 16.sp,
                                secondText: DateFormatToBrazil.formatDate(controller.dateFilter),
                                secondTextColor: AppColors.blackColor,
                                secondTextFontWeight: FontWeight.bold,
                                secondTextSize: 16.sp,
                                secondTextDecoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GetBuilder(
                          id: 'visit-list',
                          init: controller,
                          builder: (_) => Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: controller.operatorVisitList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: controller.operatorVisitList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                                    itemBuilder: (context, index) {
                                      return OperatorVisitCardWidget(
                                        visitOfOperatorsViewController: controller.operatorVisitList[index],
                                        operatorsVisitsController: controller,
                                        showBody: false,
                                      );
                                    },
                                  )
                                : Center(
                                    child: TextWidget(
                                      controller.userSelected.value.isNotEmpty
                                          ? "Não existe visitas para esse usuário nesta data"
                                          : "",
                                      textColor: AppColors.grayTextColor,
                                      fontSize: 14.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.h),
                        child: ButtonWidget(
                          hintText: "FILTRAR",
                          fontWeight: FontWeight.bold,
                          widthButton: double.infinity,
                          onPressed: () => controller.getVisitsUser(),
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
