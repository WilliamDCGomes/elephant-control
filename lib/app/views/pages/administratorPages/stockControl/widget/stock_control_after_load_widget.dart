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
                              child: TitleWithBackButtonWidget(
                                title: "Controle de Estoque",
                              ),
                            ),
                          ],
                        ),
                      ),
                      InformationContainerWidget(
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
                                secondText: DateFormatToBrazil.formatDateAndHour(
                                  controller.quantityLastUpdate.value
                                ),
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
                    ],
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: Column(
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
                        padding: EdgeInsets.only(top: 2.h),
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
                controller.loadingWithSuccessOrErrorWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
