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
import '../widgets/financial_history_card__widget.dart';

class FinancialHistoryAdministratorAfterLoadWidget extends StatefulWidget {
  final bool disableSearch;

  const FinancialHistoryAdministratorAfterLoadWidget({
    Key? key,
    this.disableSearch = false,
  }) : super(key: key);

  @override
  State<FinancialHistoryAdministratorAfterLoadWidget> createState() => _FinancialHistoryAdministratorAfterLoadWidgetState();
}

class _FinancialHistoryAdministratorAfterLoadWidgetState extends State<FinancialHistoryAdministratorAfterLoadWidget> {
  late FinancialHistoryAdministratorController controller;

  @override
  void initState() {
    controller = Get.find(tag: "financial-history-administrator-controller");
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
                        child: Obx(
                          () => TitleWithBackButtonWidget(
                            title: "Histórico Cofre da Tesouraria",
                            rightIcon: controller.showInfos.value ? Icons.visibility_off : Icons.visibility,
                            onTapRightIcon: () => controller.showInfos.value = !controller.showInfos.value,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Obx(
                              () => Visibility(
                                visible: controller.showInfos.value,
                                child: InformationContainerWidget(
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
                                      Visibility(
                                        visible: !widget.disableSearch,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !widget.disableSearch,
                              child: Obx(
                                () => Padding(
                                  padding: EdgeInsets.only(left: 2.h, top: 1.h, right: 2.h, bottom: 2.h),
                                  child: DropdownButtonRxListWidget(
                                    itemSelected: controller.userSelected.value == "" ? null : controller.userSelected.value,
                                    hintText: "Usuário",
                                    height: PlatformType.isTablet(context) ? 5.6.h : 6.5.h,
                                    width: 90.w,
                                    rxListItems: controller.usersName,
                                    onChanged: (selectedState) {
                                      if(selectedState != null) {
                                        controller.userSelected.value = selectedState;
                                        controller.getVisitsUser();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GetBuilder(
                                id: "safebox-list",
                                init: controller,
                                builder: (_) => controller.safeBoxHistoryList.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: controller.safeBoxHistoryList.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                                        itemBuilder: (context, index) {
                                          return FinancialHistoryCardWidget(
                                            safeBoxFinancialViewController: controller.safeBoxHistoryList[index],
                                          );
                                        },
                                      )
                                    : Center(
                                        child: TextWidget(
                                          controller.userSelected.value.isNotEmpty
                                              ? "Não existe valores no histórico do cofre desse usuário"
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
