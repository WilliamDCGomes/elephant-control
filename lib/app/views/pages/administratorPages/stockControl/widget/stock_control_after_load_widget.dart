import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../stockistPages/addPlushInStock/page/add_plush_in_stock_page.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/stock_control_controller.dart';

class StockControlAfterLoadWidget extends StatefulWidget {
  const StockControlAfterLoadWidget({Key? key}) : super(key: key);

  @override
  State<StockControlAfterLoadWidget> createState() => _StockControlAfterLoadWidgetState();
}

class _StockControlAfterLoadWidgetState extends State<StockControlAfterLoadWidget> {
  late final StockControlController controller;
  @override
  void initState() {
    controller = Get.find(tag: "stock-control-controller");
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(
                                () => TitleWithBackButtonWidget(
                                  title: "Controle de Estoque",
                                  rightIcon: controller.showInfos.value ? Icons.visibility_off : Icons.visibility,
                                  onTapRightIcon: () => controller.showInfos.value = !controller.showInfos.value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: controller.showInfos.value,
                          child: InformationContainerWidget(
                            iconPath: Paths.Pelucia,
                            textColor: AppColors.whiteColor,
                            backgroundColor: AppColors.defaultColor,
                            informationText: "",
                            customContainer: Obx(
                              () => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: RichTextTwoDifferentWidget(
                                      firstText: "Total de pelúcias no estoque: ",
                                      firstTextColor: AppColors.whiteColor,
                                      firstTextFontWeight: FontWeight.normal,
                                      firstTextSize: 18.sp,
                                      secondText: FormatNumbers.scoreIntNumber(
                                        controller.plushQuantity.value,
                                      ),
                                      secondTextColor: AppColors.whiteColor,
                                      secondTextFontWeight: FontWeight.bold,
                                      secondTextSize: 18.sp,
                                      secondTextDecoration: TextDecoration.none,
                                      maxLines: 2,
                                    ),
                                  ),
                                  RichTextTwoDifferentWidget(
                                    firstText: "Última atualização: ",
                                    firstTextColor: AppColors.whiteColor,
                                    firstTextFontWeight: FontWeight.normal,
                                    firstTextSize: 18.sp,
                                    secondText: DateFormatToBrazil.formatDateAndHour(controller.quantityLastUpdate.value),
                                    secondTextColor: AppColors.whiteColor,
                                    secondTextFontWeight: FontWeight.bold,
                                    secondTextSize: 18.sp,
                                    secondTextDecoration: TextDecoration.none,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Obx(
                        () => Padding(
                          padding: EdgeInsets.fromLTRB(2.h, 0, 2.h, 1.h),
                          child: ListView.builder(
                            itemCount: controller.stockistLog.length,
                            itemBuilder: (context, index) {
                              final stockistLog = controller.stockistLog[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 2.h, top: 1.h),
                                decoration: BoxDecoration(
                                  color: AppColors.defaultColor,
                                  borderRadius: BorderRadius.circular(2.h),
                                ),
                                // height: 5.h,
                                width: 100.w,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          TextWidget(
                                            "Data: ",
                                            textColor: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                            textAlign: TextAlign.start,
                                            maxLines: 3,
                                          ),
                                          TextWidget(
                                            DateFormatToBrazil.formatDate(stockistLog.inclusion),
                                            textColor: AppColors.whiteColor,
                                            fontSize: 16.sp,
                                            textAlign: TextAlign.start,
                                            maxLines: 3,
                                          ),
                                          Spacer(),
                                          Icon(stockistLog.added ? Icons.add : Icons.remove, color: AppColors.whiteColor),
                                        ],
                                      ),
                                      SizedBox(height: 1.h),
                                      TextWidget(
                                        "Descrição:",
                                        textColor: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
                                      ),
                                      TextWidget(
                                        stockistLog.description,
                                        textColor: AppColors.whiteColor,
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.start,
                                        maxLines: 3,
                                      ),
                                      if (stockistLog.observation.isNotEmpty)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 1.h),
                                            TextWidget(
                                              "Observações:",
                                              textColor: AppColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                            ),
                                            TextWidget(
                                              stockistLog.observation,
                                              textColor: AppColors.whiteColor,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )),
                      Obx(
                        () => Visibility(
                          visible: controller.showInfos.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton.extended(
                                heroTag: "firstFloatingActionButton",
                                backgroundColor: AppColors.defaultColor,
                                foregroundColor: AppColors.backgroundColor,
                                elevation: 3,
                                icon: Image.asset(
                                  Paths.Pelucia_Add,
                                  height: 3.h,
                                  color: AppColors.whiteColor,
                                ),
                                label: TextWidget(
                                  "Adicionar Pelúcias ao Estoque",
                                  maxLines: 1,
                                  textColor: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () async {
                                  await Get.to(() => AddPlushInStockPage());
                                  await controller.getQuantityData();
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: FloatingActionButton.extended(
                                  heroTag: "secondFloatingActionButton",
                                  backgroundColor: AppColors.defaultColor,
                                  foregroundColor: AppColors.backgroundColor,
                                  elevation: 3,
                                  icon: Image.asset(
                                    Paths.Pelucia_Remove,
                                    height: 3.h,
                                    color: AppColors.whiteColor,
                                  ),
                                  label: TextWidget(
                                    "Remover Pelúcias ao Estoque",
                                    maxLines: 1,
                                    textColor: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () async {
                                    await Get.to(() => AddPlushInStockPage(
                                          removePlush: true,
                                        ));
                                    await controller.getQuantityData();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
