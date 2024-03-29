import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/financial_history_administrator_controller.dart';
import '../widgets/financial_history_administrator_after_load_widget.dart';

class FinancialHistoryAdministratorPage extends StatefulWidget {
  final bool disableSearch;

  const FinancialHistoryAdministratorPage({
    Key? key,
    this.disableSearch = false,
  }) : super(key: key);

  @override
  State<FinancialHistoryAdministratorPage> createState() => _FinancialHistoryAdministratorPageState();
}

class _FinancialHistoryAdministratorPageState extends State<FinancialHistoryAdministratorPage> {
  late FinancialHistoryAdministratorController controller;

  @override
  void initState() {
    controller = Get.put(
      FinancialHistoryAdministratorController(
        disableSearch: widget.disableSearch,
      ),
      tag: "financial-history-administrator-controller",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(pageTitle: "Histórico Cofre da Tesouraria") :
        FinancialHistoryAdministratorAfterLoadWidget(
          disableSearch: widget.disableSearch,
        ),
      ),
    );
  }
}
