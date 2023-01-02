import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../../utils/paths.dart';
import '../../../../../utils/platform_type.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/dropdown_button_rxlist_wdiget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/operator_financial_pouch_controller.dart';
import '../widget/pouch_card_widget.dart';

class OperatorFinancialPouchPage extends StatefulWidget {
  final bool withOperator;

  const OperatorFinancialPouchPage({
    Key? key,
    required this. withOperator,
  }) : super(key: key);

  @override
  State<OperatorFinancialPouchPage> createState() => _OperatorFinancialPouchPageState();
}

class _OperatorFinancialPouchPageState extends State<OperatorFinancialPouchPage> {
  late OperatorPouchController controller;

  @override
  void initState() {
    controller = Get.put(OperatorPouchController(widget.withOperator));
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
                        child: TitleWithBackButtonWidget(
                          title: "Malotes com " + (widget.withOperator ? "Operadores" : "Tesouraria"),
                        ),
                      ),
                      InformationContainerWidget(
                        iconPath: widget. withOperator ?
                        Paths.Malote : Paths.Malote_Com_Tesouraria,
                        textColor: AppColors.whiteColor,
                        backgroundColor: AppColors.defaultColor,
                        informationText: "",
                        customContainer: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "Todos os Malotes na posse " + (widget.withOperator ? "dos Operadores" : "da Tesouraria"),
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
                              "Selecione um usuário para visualizar os malotes",
                              textColor: AppColors.whiteColor,
                              fontSize: 16.sp,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Obx(
                              () => RichTextTwoDifferentWidget(
                                firstText: "Valor Total: ",
                                firstTextColor: AppColors.whiteColor,
                                firstTextFontWeight: FontWeight.normal,
                                firstTextSize: 18.sp,
                                secondText: FormatNumbers.numbersToMoney(controller.fullValue.value),
                                secondTextColor: AppColors.whiteColor,
                                secondTextFontWeight: FontWeight.bold,
                                secondTextSize: 18.sp,
                                secondTextDecoration: TextDecoration.none,
                                maxLines: 2,
                              ),
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
                            width: 90.w,
                            rxListItems: controller.usersName,
                            onChanged: (selectedState) {
                              if(selectedState != null) {
                                controller.userSelected.value = selectedState;
                                controller.getPouchUser();
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: GetBuilder(
                          id: "list-pouch",
                          init: controller,
                          builder: (_) => controller.moneyPouchGetViewController != null && controller.moneyPouchGetViewController!.moneyPouchValueList.isNotEmpty ? ListView.builder(
                            itemCount: controller.moneyPouchGetViewController!.moneyPouchValueList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 2.h),
                            itemBuilder: (context, index){
                              return PouchCardWidget(
                                userName: controller.userSelected.value,
                                moneyPouchValueList: controller.moneyPouchGetViewController!.moneyPouchValueList[index],
                              );
                            },
                          ) : Center(
                            child: TextWidget(
                              controller.userSelected.value.isNotEmpty ? "Não existem malotes no saldo desse usuário" : "",
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
                controller.loadingWithSuccessOrErrorWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
