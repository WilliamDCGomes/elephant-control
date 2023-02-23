import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/viewControllers/report_viewcontroller.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';

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
                firstText: "Valor total cartão de crédito dos malotes: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.numbersToMoney(reportViewController.creditValue),
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
                firstText: "Valor total cartão de débito dos malotes: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.numbersToMoney(reportViewController.debitValue),
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
                firstText: "Valor total PIX dos malotes: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.numbersToMoney(reportViewController.pixValue),
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
                firstText: "Valor total dos malotes: ",
                firstTextColor: AppColors.blackColor,
                firstTextFontWeight: FontWeight.normal,
                firstTextSize: 18.sp,
                secondText: FormatNumbers.numbersToMoney(reportViewController.totalPouchValue),
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
