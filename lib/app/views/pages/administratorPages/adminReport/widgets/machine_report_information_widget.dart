import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/viewControllers/report_viewcontroller.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_widget.dart';

class MachineReportInformationWidget extends StatelessWidget {
  final ReportViewController reportViewController;

  const MachineReportInformationWidget({
    Key? key,
    required this.reportViewController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        RichTextTwoDifferentWidget(
          firstText: "Total de pelúcias adicionadas na máquina: ",
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
            firstText: "Total de pelúcias que saíram na máquina: ",
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
            firstText: "Total de pelúcias estimado na máquina: ",
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
            firstText: "Valor da máquina: ",
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
        Padding(
          padding: EdgeInsets.only(top: 1.5.h),
          child: TextWidget(
            "Médias programada para a máquina",
            textColor: AppColors.blackColor,
            fontSize: 18.sp,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: .5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichTextTwoDifferentWidget(
                firstText: "Mínima: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.numbersToString(reportViewController.minimumAverageValue),
                secondTextColor: AppColors.blackColor,
                secondTextFontWeight: FontWeight.bold,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                maxLines: 2,
              ),
              RichTextTwoDifferentWidget(
                firstText: "Máxima: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.numbersToString(reportViewController.maximumAverageValue),
                secondTextColor: AppColors.blackColor,
                secondTextFontWeight: FontWeight.bold,
                secondTextSize: 18.sp,
                secondTextDecoration: TextDecoration.none,
                maxLines: 2,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 1.5.h),
          child: RichTextTwoDifferentWidget(
            firstText: "Média geral da máquina: ",
            firstTextColor: AppColors.blackColor,
            firstTextFontWeight: FontWeight.normal,
            firstTextSize: 18.sp,
            secondText: FormatNumbers.numbersToString(reportViewController.averageValue),
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
            firstText: "Quantidade de visitas na máquina: ",
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
        if(reportViewController.visitDays != null)
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppColors.blackColor,
                ),
                borderRadius: BorderRadius.circular(
                    1.h
                ),
              ),
              child: ExpansionTile(
                title: TextWidget(
                  "Datas em que a máquina foi visitada",
                  textColor: AppColors.blackColor,
                  fontSize: 16.sp,
                  textAlign: TextAlign.start,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reportViewController.visitDays!.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: .5.h),
                        child: TextWidget(
                          DateFormatToBrazil.formatDateAndHour(
                            reportViewController.visitDays![index],
                          ),
                          textColor: AppColors.blackColor,
                          fontSize: 18.sp,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
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
        if(reportViewController.pouchCollectedDates != null)
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppColors.blackColor,
                ),
                borderRadius: BorderRadius.circular(
                    1.h
                ),
              ),
              child: ExpansionTile(
                title: TextWidget(
                  "Datas em que os malotes foram coletados",
                  textColor: AppColors.blackColor,
                  fontSize: 16.sp,
                  textAlign: TextAlign.start,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reportViewController.pouchCollectedDates!.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: .5.h),
                        child: TextWidget(
                          DateFormatToBrazil.formatDateAndHour(
                            reportViewController.pouchCollectedDates![index],
                          ),
                          textColor: AppColors.blackColor,
                          fontSize: 18.sp,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
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
            firstText: "Quantidade de vezes em que a máquina esteve fora da média: ",
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
        if(reportViewController.outOffAverageDates != null)
          Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppColors.blackColor,
                ),
                borderRadius: BorderRadius.circular(
                    1.h
                ),
              ),
              child: ExpansionTile(
                title: TextWidget(
                  "Datas e valor da máquina fora da média",
                  textColor: AppColors.blackColor,
                  fontSize: 16.sp,
                  textAlign: TextAlign.start,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reportViewController.outOffAverageDates!.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: .5.h),
                        child: TextWidget(
                          DateFormatToBrazil.formatDateAndHour(
                            reportViewController.outOffAverageDates![index],
                          ) + " - Valor: " +
                              FormatNumbers.numbersToString(
                                reportViewController.outOffAverageValues![index],
                              ),
                          textColor: AppColors.blackColor,
                          fontSize: 18.sp,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                          maxLines: 2,
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
      ],
    );
  }
}