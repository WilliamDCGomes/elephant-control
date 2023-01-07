import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  final String title;
  final String pageTitle;
  final List<Visit> visits;

  const HistoryPage({
    Key? key,
    required this.title,
    required this.pageTitle,
    required this.visits,
  }) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryController controller;

  @override
  void initState() {
    controller = Get.put(HistoryController(widget.title));
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
                                  Visibility(
                                    visible: widget.title == "Histórico de Pelúcias",
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextWidget(
                                          "Saldo Inicial: 0",
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
                                          "Saldo Atual: 0",
                                          textColor: AppColors.whiteColor,
                                          fontSize: 18.sp,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextWidget(
                                    "Dia: ${DateFormatToBrazil.formatDate(DateTime.now())}",
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
                              child: ListView.builder(
                                itemCount: widget.visits.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                itemBuilder: (context, index) {
                                  final visit = widget.visits[index];
                                  return MaintenanceCardWidget(
                                    machineName: visit.machine!.name,
                                    city: visit.machine!.city,
                                    status: visit.status.description,
                                    workPriority: "NORMAL",
                                    priorityColor: AppColors.greenColor.value,
                                    clock1: FormatNumbers.numbersToMoney(visit.moneyQuantity),
                                    clock2: visit.stuffedAnimalsQuantity.toString(),
                                    teddy: visit.stuffedAnimalsReplaceQuantity.toString(),
                                    pouchCollected: visit.moneyWithdrawalQuantity != null,
                                    showPriorityAndStatus: false,
                                  );
                                },
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
