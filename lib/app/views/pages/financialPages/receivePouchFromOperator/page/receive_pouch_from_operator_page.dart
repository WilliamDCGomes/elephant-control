import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/dropdown_button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/receive_pouch_from_operator_controller.dart';

class ReceivePouchFromOperator extends StatefulWidget {
  const ReceivePouchFromOperator({Key? key}) : super(key: key);

  @override
  State<ReceivePouchFromOperator> createState() => _ReceivePouchFromOperatorState();
}

class _ReceivePouchFromOperatorState extends State<ReceivePouchFromOperator> {
  late ReceivePouchFromOperatorController controller;

  @override
  void initState() {
    controller = Get.put(ReceivePouchFromOperatorController());
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
                          title: "Receber Malote",
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
                                    "Adicionar novo Malote",
                                    textColor: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Obx(
                                    () => TextWidget(
                                      "Malotes com o operador: ${controller.pouchWithOperators.value}",
                                      textColor: AppColors.whiteColor,
                                      fontSize: 18.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      fontWeight: FontWeight.bold,
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
                                        "Selecione o operador",
                                        textColor: AppColors.defaultColor,
                                        fontSize: 16.sp,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  GetBuilder(
                                      id: "dropdown",
                                      init: controller,
                                      builder: (context) {
                                        return DropdownButtonWidget(
                                          itemSelected: controller.operatorSelected?.id,
                                          hintText: "Operadores",
                                          height: 6.5.h,
                                          width: 85.w,
                                          listItems: controller.operators
                                              .map((element) => DropdownItem(item: element.name, value: element.id)),
                                          onChanged: (selectedState) =>
                                              controller.onDropdownButtonWidgetChanged(selectedState),
                                        );
                                      }),
                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //     top: 3.5.h,
                                  //   ),
                                  //   child: Form(
                                  //     //key: controller.formKey,
                                  //     child: TextFieldWidget(
                                  //       //validator: (value) => TextFieldValidators.defaultValidator(value, errorMessage: "Preencha o código do operador"),
                                  //       controller: controller.operatorCode,
                                  //       hintText: "Código do Operador",
                                  //       height: 9.h,
                                  //       maskTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                  //       keyboardType: TextInputType.number,
                                  //     ),
                                  //   ),
                                  // ),
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
                              padding: EdgeInsets.only(left: 2.h, top: 2.h, right: 2.h),
                              child: ButtonWidget(
                                hintText: "SELECIONAR MALOTES",
                                fontWeight: FontWeight.bold,
                                widthButton: 100.w,
                                onPressed: () => controller.openPouchList(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.h),
                              child: ButtonWidget(
                                hintText: "SALVAR",
                                fontWeight: FontWeight.bold,
                                widthButton: 100.w,
                                onPressed: () => controller.saveReceivedPouch(),
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
