import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../../../utils/money_mask.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/dropdown_button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/register_pouch_controller.dart';

class RegisterPouchPage extends StatefulWidget {
  const RegisterPouchPage({Key? key}) : super(key: key);

  @override
  State<RegisterPouchPage> createState() => _RegisterPouchPageState();
}

class _RegisterPouchPageState extends State<RegisterPouchPage> {
  late RegisterPouchController controller;

  @override
  void initState() {
    controller = Get.put(RegisterPouchController());
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
                          title: "Lançar Malote",
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Malote,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    "Adicionar Saldo do Malote",
                                    textColor: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(height: 2.h),
                                  Obx(
                                    () => RichTextTwoDifferentWidget(
                                      firstText: "Valor total: ",
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
                                  Obx(
                                    () => Visibility(
                                      visible: (controller.estimateValue.value - controller.fullValue.value > 20
                                      || controller.estimateValue.value - controller.fullValue.value < -20)
                                      && controller.fullValue.value != 0,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: RichTextTwoDifferentWidget(
                                          firstText: "Diferença: ",
                                          firstTextColor: AppColors.whiteColor,
                                          firstTextFontWeight: FontWeight.normal,
                                          firstTextSize: 18.sp,
                                          secondText: FormatNumbers.stringToMoney(controller.getDifference()),
                                          secondTextColor: AppColors.whiteColor,
                                          secondTextFontWeight: FontWeight.bold,
                                          secondTextSize: 18.sp,
                                          secondTextDecoration: TextDecoration.none,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 2.h),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextWidget(
                                      "Preencha os dados",
                                      textColor: AppColors.blackColor,
                                      fontSize: 18.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextWidget(
                                        "Selecione o malote que deseja lançar",
                                        textColor: AppColors.defaultColor,
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => DropdownButtonWidget(
                                      itemSelected: controller.pouchSelected.value == "" ? null : controller.pouchSelected.value,
                                      hintText: "Malotes",
                                      height: 6.5.h,
                                      width: 85.w,
                                      listItems: controller.pouchs.map((element) => DropdownItem(item: element, value: element)),
                                      onChanged: (selectedState) => controller.onDropdownButtonWidgetChanged(selectedState),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.h,),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: controller.credCardValue,
                                            hintText: "Cartão Crédito",
                                            height: 9.h,
                                            keyboardType: TextInputType.number,
                                            maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly, MoneyMask()],
                                            onChanged: (value) => controller.calculeNewValue(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: controller.debtCardValue,
                                            hintText: "Cartão Débito",
                                            height: 9.h,
                                            keyboardType: TextInputType.number,
                                            maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly, MoneyMask()],
                                            onChanged: (value) => controller.calculeNewValue(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5.h,),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: controller.pouchValue,
                                            hintText: "Valor do Malote",
                                            height: 9.h,
                                            keyboardType: TextInputType.number,
                                            maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly, MoneyMask()],
                                            onChanged: (value) => controller.calculeNewValue(),
                                          ),
                                        ),
                                        SizedBox(width: 3.w,),
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: controller.pixValue,
                                            hintText: "Valor PIX",
                                            height: 9.h,
                                            keyboardType: TextInputType.number,
                                            maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly, MoneyMask()],
                                            onChanged: (value) => controller.calculeNewValue(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.5.h,
                                      bottom: 3.h,
                                    ),
                                    child: TextFieldWidget(
                                      controller: controller.observations,
                                      height: 19.h,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      textAlignVertical: TextAlignVertical.top,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        label: TextWidget(
                                          "Observação",
                                          fontSize: 16.sp,
                                          textColor: AppColors.defaultColor,
                                        ),
                                        alignLabelWithHint: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppColors.defaultColor,
                                            width: .25.h,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppColors.defaultColor,
                                            width: .25.h,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppColors.defaultColor,
                                            width: .25.h,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(1.5.h),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
                              child: ButtonWidget(
                                hintText: "SALVAR",
                                fontWeight: FontWeight.bold,
                                widthButton: 100.w,
                                onPressed: () {},
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
