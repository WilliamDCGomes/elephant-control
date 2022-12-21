import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/financial_history_controller.dart';

class FinancialHistoryPage extends StatefulWidget {
  final String title;
  final String pageTitle;
  final double? safeBoxAmount;
  final bool pouchHistory;

  const FinancialHistoryPage({
    Key? key,
    required this.title,
    required this.pageTitle,
    this.safeBoxAmount,
    required this.pouchHistory,
  }) : super(key: key);

  @override
  State<FinancialHistoryPage> createState() => _FinancialHistoryPageState();
}

class _FinancialHistoryPageState extends State<FinancialHistoryPage> {
  late FinancialHistoryController controller;

  @override
  void initState() {
    controller = Get.put(FinancialHistoryController(
      widget.title,
      widget.safeBoxAmount,
      widget.pouchHistory,
    ));
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
                          title: widget.pageTitle,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Pelucia,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextWidget(
                                    widget.title,
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
                                    widget.pouchHistory ? "Quantidade de Malotes: ${controller.safeBoxCardWidgetList.length}"
                                    : "Valor do Cofre: " + FormatNumbers.numbersToMoney(controller.safeBoxAmount),
                                    textColor: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () => ListView.builder(
                                  itemCount: controller.safeBoxCardWidgetList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                                  itemBuilder: (context, index){
                                    return controller.safeBoxCardWidgetList[index];
                                  },
                                ),
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