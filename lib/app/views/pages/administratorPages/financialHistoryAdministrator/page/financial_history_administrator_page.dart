import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../utils/format_numbers.dart';
import '../../../../../utils/paths.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/dropdown_button_rxlist_wdiget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/financial_history_administrator_controller.dart';

class FinancialHistoryAdministratorPage extends StatefulWidget {
  const FinancialHistoryAdministratorPage({Key? key}) : super(key: key);

  @override
  State<FinancialHistoryAdministratorPage> createState() => _FinancialHistoryAdministratorPageState();
}

class _FinancialHistoryAdministratorPageState extends State<FinancialHistoryAdministratorPage> {
  late FinancialHistoryAdministratorController controller;

  @override
  void initState() {
    controller = Get.put(FinancialHistoryAdministratorController());
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
                          title: "Histórico Cofre da Tesouraria",
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Cofre,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextWidget(
                                    "Histórico do Cofre",
                                    textColor: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Obx(
                                    () => TextWidget(
                                      "Valor do Cofre: " + FormatNumbers.numbersToMoney(controller.safeBoxAmount.value),
                                      textColor: AppColors.whiteColor,
                                      fontSize: 18.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  TextWidget(
                                    "Selecione um usuário para visualizar o Histórico do Cofre",
                                    textColor: AppColors.whiteColor,
                                    fontSize: 16.sp,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => Padding(
                                padding: EdgeInsets.only(left: 2.h, top: 1.h, right: 2.h, bottom: 2.h),
                                child: DropdownButtonRxListWidget(
                                  itemSelected: controller.userSelected.value == "" ? null : controller.userSelected.value,
                                  hintText: "Usuário",
                                  height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                  rxListItems: controller.usersName,
                                  onChanged: (selectedState) {
                                    if(selectedState != null) {
                                      controller.userSelected.value = selectedState;
                                      controller.getVisitsUser(selectedState);
                                    }
                                  },
                                ),
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