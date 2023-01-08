import 'package:elephant_control/app/views/pages/widgetsShared/shimmer/default_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controller/operator_financial_pouch_controller.dart';
import '../widgets/operator_financial_pouch_after_load_widget.dart';

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
    controller = Get.put(OperatorPouchController(widget.withOperator), tag: "operator-pouch-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
      () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Malotes com " + (widget.withOperator ? "Operadores" : "Tesouraria"),
          mainCardSize: 20.h,
          cardsSize: 10.h,
        ) :
        OperatorFinancialPouchAfterLoadWidget(
          withOperator: widget.withOperator,
        ),
      ),
    );
  }
}
