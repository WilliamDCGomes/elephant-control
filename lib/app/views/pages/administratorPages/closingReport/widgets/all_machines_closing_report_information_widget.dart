import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/viewControllers/report_viewcontroller.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_widget.dart';

class AllMachinesClosingReportInformationWidget extends StatelessWidget {
  final ReportViewController reportViewController;

  const AllMachinesClosingReportInformationWidget({
    Key? key,
    required this.reportViewController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      child: Padding(
        padding: EdgeInsets.only(right: 3.w),
        child: ListView(
          shrinkWrap: true,
          children: [
            RichTextTwoDifferentWidget(
              firstText: "Total de pelúcias adicionadas nas máquinas: ",
              firstTextColor: AppColors.blackColor,
              firstTextFontWeight: FontWeight.normal,
              firstTextSize: 18.sp,
              secondText: FormatNumbers.scoreIntNumber(reportViewController.plushAdded),
              secondTextColor: AppColors.blackColor,
              secondTextFontWeight: FontWeight.bold,
              secondTextSize: 18.sp,
              secondTextDecoration: TextDecoration.none,
              maxLines: 2,
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: RichTextTwoDifferentWidget(
                firstText: "Total de pelúcias que saíram das máquinas: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.scoreIntNumber(reportViewController.plushRemoved),
                secondTextColor: AppColors.blackColor,
                secondTextFontWeight: FontWeight.bold,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: RichTextTwoDifferentWidget(
                firstText: "Total de pelúcias estimado nas máquinas: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.scoreIntNumber(reportViewController.plushInTheMachine),
                secondTextColor: AppColors.blackColor,
                secondTextFontWeight: FontWeight.bold,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: RichTextTwoDifferentWidget(
                firstText: "Valor das máquinas: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.intToMoney(reportViewController.machineValue),
                secondTextColor: AppColors.blackColor,
                secondTextFontWeight: FontWeight.bold,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                maxLines: 2,
              ),
            ),
            if (reportViewController.creditValue != null && reportViewController.debitValue != null && reportViewController.pixValue != null && reportViewController.totalPouchValue != null)
              Padding(
                padding: EdgeInsets.only(top: 1.5.h),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.blackColor,
                    ),
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                  child: ExpansionTile(
                    title: TextWidget(
                      "Valores da máquina",
                      textColor: AppColors.blackColor,
                      fontSize: 16.sp,
                      textAlign: TextAlign.start,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: .5.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 2.h,
                                  width: 2.h,
                                  margin: EdgeInsets.only(right: 2.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColor,
                                    borderRadius: BorderRadius.circular(
                                      1.h,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    "Dinheiro: " +
                                        FormatNumbers.numbersToMoney(reportViewController.totalPouchValue),
                                    textColor: AppColors.blackColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: .5.h),
                              child: Divider(
                                color: AppColors.defaultColor,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 2.h,
                                  width: 2.h,
                                  margin: EdgeInsets.only(right: 2.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColor,
                                    borderRadius: BorderRadius.circular(
                                      1.h,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    "Cartão de Crédito: " +
                                        FormatNumbers.numbersToMoney(reportViewController.creditValue),
                                    textColor: AppColors.blackColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: .5.h),
                              child: Divider(
                                color: AppColors.defaultColor,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 2.h,
                                  width: 2.h,
                                  margin: EdgeInsets.only(right: 2.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColor,
                                    borderRadius: BorderRadius.circular(
                                      1.h,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    "Cartão de Débito: " +
                                        FormatNumbers.numbersToMoney(reportViewController.debitValue),
                                    textColor: AppColors.blackColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: .5.h),
                              child: Divider(
                                color: AppColors.defaultColor,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 2.h,
                                  width: 2.h,
                                  margin: EdgeInsets.only(right: 2.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColor,
                                    borderRadius: BorderRadius.circular(
                                      1.h,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextWidget(
                                    "Valor no Pix: " +
                                        FormatNumbers.numbersToMoney(reportViewController.pixValue),
                                    textColor: AppColors.blackColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                    ],
                  ),
                ),
              ),
            if (reportViewController.getMachineName.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 1.5.h),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.blackColor,
                    ),
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                  child: ExpansionTile(
                    title: TextWidget(
                      "Valores nas datas iniciais e finais de cada máquina",
                      textColor: AppColors.blackColor,
                      fontSize: 16.sp,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reportViewController.getMachineName.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: .5.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 2.h,
                                      width: 2.h,
                                      margin: EdgeInsets.only(right: 2.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.defaultColor,
                                        borderRadius: BorderRadius.circular(
                                          1.h,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            (reportViewController.getMachineName[index]["machineName"] ?? ""),
                                            textColor: AppColors.blackColor,
                                            fontSize: 18.sp,
                                            textAlign: TextAlign.start,
                                            fontWeight: FontWeight.bold,
                                            maxLines: 2,
                                            textDecoration: TextDecoration.underline,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.w, top: .5.h),
                                            child: TextWidget(
                                              "Primeira Visita:",
                                              textColor: AppColors.blackColor,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.w, top: .5.h),
                                            child: TextWidget(
                                              "Valor: ${FormatNumbers.stringToMoney(reportViewController.getMachineName[index]["firstMoneyQuantity"] ?? "")}",
                                              textColor: AppColors.blackColor,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.w, top: .5.h),
                                            child: TextWidget(
                                              "Data: ${DateFormatToBrazil.formatDateFromReport(reportViewController.getMachineName[index]["firstMachineDate"] ?? "")}",
                                              textColor: AppColors.blackColor,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.w, top: .5.h),
                                            child: TextWidget(
                                              "Última Visita:",
                                              textColor: AppColors.blackColor,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.w, top: .5.h),
                                            child: TextWidget(
                                              "Valor: ${FormatNumbers.stringToMoney(reportViewController.getMachineName[index]["secondMoneyQuantity"] ?? "")}",
                                              textColor: AppColors.blackColor,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.w, top: .5.h),
                                            child: TextWidget(
                                              "Data: ${DateFormatToBrazil.formatDateFromReport(reportViewController.getMachineName[index]["secondMachineDate"] ?? "")}",
                                              textColor: AppColors.blackColor,
                                              fontSize: 16.sp,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: .5.h),
                                            child: TextWidget(
                                              "Valor do Período: ${FormatNumbers.numbersToMoney(FormatNumbers.stringToNumber(reportViewController.getMachineName[index]["secondMoneyQuantity"] ?? "") - FormatNumbers.stringToNumber(reportViewController.getMachineName[index]["firstMoneyQuantity"] ?? ""))}",
                                              textColor: AppColors.blackColor,
                                              fontSize: 18.sp,
                                              textAlign: TextAlign.start,
                                              fontWeight: FontWeight.bold,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: .5.h),
                                  child: Divider(
                                    color: AppColors.defaultColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: RichTextTwoDifferentWidget(
                firstText: "Quantidade de visitas nas máquinas: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.scoreIntNumber(reportViewController.numbersOfVisits),
                secondTextColor: AppColors.blackColor,
                secondTextFontWeight: FontWeight.bold,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: RichTextTwoDifferentWidget(
                firstText: "Quantidade de vezes que os malotes foram coletados: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.scoreIntNumber(reportViewController.numbersOfPouchRemoved),
                secondTextColor: AppColors.blackColor,
                secondTextFontWeight: FontWeight.bold,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.5.h),
              child: RichTextTwoDifferentWidget(
                firstText: "Quantidade de vezes em que as máquinas estiveram fora da média: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.scoreIntNumber(reportViewController.numbersOfTimesOutOffAverage),
                secondTextColor: AppColors.blackColor,
                secondTextFontWeight: FontWeight.bold,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
