import 'dart:ui';
import 'package:elephant_control/app/views/pages/financialPages/receivePouchFromOperator/widget/pouch_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../controller/receive_pouch_from_operator_controller.dart';

class ReceivePouchPopup extends StatefulWidget {
  final ReceivePouchFromOperatorController controller;

  const ReceivePouchPopup({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ReceivePouchPopup> createState() => _ReceivePouchPopupState();
}

class _ReceivePouchPopupState extends State<ReceivePouchPopup> {
  late bool showPopup;

  @override
  void initState() {
    showPopup = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 150));
      setState(() {
        showPopup = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Visibility(
        visible: showPopup,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.h),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(2.h),
                  color: AppColors.defaultColor,
                  child: TextWidget(
                    "Selecione os malotes que está recebendo",
                    textColor: AppColors.whiteColor,
                    fontSize: 18.sp,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => SizedBox(
                    height: 60.h,
                    child: Scrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: widget.controller.pouchList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(2.h),
                        itemBuilder: (context, index) {
                          final moneyPouch = widget.controller.pouchList[index];
                          return PouchWidget(moneyPouch: moneyPouch);
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 2.h),
                  child: ButtonWidget(
                    hintText: "SALVAR",
                    fontWeight: FontWeight.bold,
                    widthButton: double.infinity,
                    onPressed: () => widget.controller.selectedPouch(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
