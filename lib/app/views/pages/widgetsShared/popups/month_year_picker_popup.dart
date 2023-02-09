import 'dart:ui';
import 'package:elephant_control/app/views/pages/widgetsShared/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../utils/platform_type.dart';
import '../../../stylePages/app_colors.dart';
import '../rich_text_two_different_widget.dart';

class MonthYearPickerPopup extends StatefulWidget {
  final DateTime? initialDate;
  final Function returnFunction;

  const MonthYearPickerPopup({
    Key? key,
    this.initialDate,
    required this.returnFunction,
  }) : super(key: key);

  @override
  _MonthYearPickerPopupState createState() => _MonthYearPickerPopupState();
}

class _MonthYearPickerPopupState extends State<MonthYearPickerPopup> {
  late bool showPopup;
  late int selectedMonth;
  late int selectedYear;
  late List<String> allMonths;
  late List<int> allYears;
  late Rx<DateTime> datePicker;

  @override
  void initState() {
    showPopup = false;
    datePicker = (widget.initialDate ?? DateTime.now()).obs;
    selectedMonth = datePicker.value.month;
    selectedYear = datePicker.value.year;
    allMonths = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro",
    ];
    allYears = <int>[];
    for(int i = 2023; i <= DateTime.now().year; i++){
      allYears.add(i);
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 150));
      setState(() {
        showPopup = true;
      });
    });
  }

  showMonthPickerDateTime(BuildContext context) {
    Picker? pickedValue = null;

    Picker(
      selecteds: [DateTime.now().month - 1],
      onSelect: (value, _, _2){
        pickedValue = value;
      },
      adapter: PickerDataAdapter<String>(
        pickerData: allMonths,
      ),
      title: TextWidget(
        "SELECIONE UM MÊS",
        fontSize: 16.sp,
        maxLines: 2,
      ),
      headerColor: AppColors.defaultColor,
      looping: true,
      footer: Container(
        padding: EdgeInsets.all(1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: TextWidget(
                "Cancelar",
                textColor: AppColors.defaultColor,
                fontSize: 18.sp,
              ),
              onTap: () {
                Get.back();
              },
            ),
            SizedBox(
              width: 5.w,
            ),
            InkWell(
              child: TextWidget(
                "Selecionar",
                textColor: AppColors.defaultColor,
                fontSize: 18.sp,
              ),
              onTap: () {
                if(pickedValue != null){
                  switch(pickedValue!.adapter.text.replaceAll('[', '').replaceAll(']', '')){
                    case "Janeiro":
                      setState(() {
                        selectedMonth = 1;
                      });
                      break;
                    case "Fevereiro":
                      setState(() {
                        selectedMonth = 2;
                      });
                      break;
                    case "Março":
                      setState(() {
                        selectedMonth = 3;
                      });
                      break;
                    case "Abril":
                      setState(() {
                        selectedMonth = 4;
                      });
                      break;
                    case "Maio":
                      setState(() {
                        selectedMonth = 5;
                      });
                      break;
                    case "Junho":
                      setState(() {
                        selectedMonth = 6;
                      });
                      break;
                    case "Julho":
                      setState(() {
                        selectedMonth = 7;
                      });
                      break;
                    case "Agosto":
                      setState(() {
                        selectedMonth = 8;
                      });
                      break;
                    case "Setembro":
                      setState(() {
                        selectedMonth = 9;
                      });
                      break;
                    case "Outubro":
                      setState(() {
                        selectedMonth = 10;
                      });
                      break;
                    case "Novembro":
                      setState(() {
                        selectedMonth = 11;
                      });
                      break;
                    case "Dezembro":
                      setState(() {
                        selectedMonth = 12;
                      });
                      break;
                  }
                }
                Get.back();
              },
            ),
          ],
        ),
      ),
    ).showBottomSheet(context);
  }

  showYearPickerDateTime(BuildContext context) {
    Picker? pickedValue = null;

    Picker(
      selecteds: [allYears.firstWhere((element) => element == DateTime.now().year)],
      onSelect: (value, _, _2){
        pickedValue = value;
      },
      adapter: PickerDataAdapter<String>(
        pickerData: allYears,
      ),
      title: TextWidget(
        "SELECIONE UM ANO",
        fontSize: 16.sp,
        maxLines: 2,
      ),
      headerColor: AppColors.defaultColor,
      looping: true,
      footer: Container(
        padding: EdgeInsets.all(1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: TextWidget(
                "Cancelar",
                textColor: AppColors.defaultColor,
                fontSize: 18.sp,
              ),
              onTap: () {
                Get.back();
              },
            ),
            SizedBox(
              width: 5.w,
            ),
            InkWell(
              child: TextWidget(
                "Selecionar",
                textColor: AppColors.defaultColor,
                fontSize: 18.sp,
              ),
              onTap: () {
                if(pickedValue != null){
                  setState(() {
                    selectedYear = int.parse(pickedValue!.adapter.text.replaceAll('[', '').replaceAll(']', ''));
                  });
                }
                Get.back();
              },
            ),
          ],
        ),
      ),
    ).showBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Visibility(
        visible: showPopup,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(.1.h),
          ),
          child: Container(
            height: 45.h,
            width: 75.w,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: Scaffold(
              backgroundColor: AppColors.transparentColor,
              body: Builder(
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 15.h,
                      width: double.infinity,
                      padding: EdgeInsets.all(1.h),
                      decoration: BoxDecoration(
                        color: AppColors.defaultColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(.1.h),
                          topLeft: Radius.circular(.1.h),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: .5.h, horizontal: 5.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              "SELECIONE UMA DATA",
                              textColor: AppColors.whiteColor,
                              fontSize: 13.sp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    allMonths[selectedMonth - 1] + " de " + allYears.firstWhere((element) => element == selectedYear).toString(),
                                    textColor: AppColors.whiteColor,
                                    fontSize: 20.sp,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Icon(
                                  Icons.edit,
                                  color: AppColors.whiteColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 30.h,
                      padding: EdgeInsets.all(2.h),
                      color: AppColors.whiteColor,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => showMonthPickerDateTime(context),
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
                              margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichTextTwoDifferentWidget(
                                  firstText: "Mês selecionado: ",
                                  firstTextColor: AppColors.blackColor,
                                  firstTextFontWeight: FontWeight.normal,
                                  firstTextSize: 16.sp,
                                  secondText: allMonths[selectedMonth - 1],
                                  secondTextColor: AppColors.blackColor,
                                  secondTextFontWeight: FontWeight.bold,
                                  secondTextSize: 16.sp,
                                  secondTextDecoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          InkWell(
                            onTap: () => showYearPickerDateTime(context),
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
                              margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichTextTwoDifferentWidget(
                                  firstText: "Ano selecionado: ",
                                  firstTextColor: AppColors.blackColor,
                                  firstTextFontWeight: FontWeight.normal,
                                  firstTextSize: 16.sp,
                                  secondText: allYears.firstWhere((element) => element == selectedYear).toString(),
                                  secondTextColor: AppColors.blackColor,
                                  secondTextFontWeight: FontWeight.bold,
                                  secondTextSize: 16.sp,
                                  secondTextDecoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: TextWidget(
                                    "Cancelar",
                                    textColor: AppColors.defaultColor,
                                    fontSize: 16.sp,
                                  ),
                                  onTap: () => Get.back(),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                InkWell(
                                  child: TextWidget(
                                    "Selecionar",
                                    textColor: AppColors.defaultColor,
                                    fontSize: 16.sp,
                                  ),
                                  onTap: () {
                                    widget.returnFunction(selectedMonth, selectedYear);
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}