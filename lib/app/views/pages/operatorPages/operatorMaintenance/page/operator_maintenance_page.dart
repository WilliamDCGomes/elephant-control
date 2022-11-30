import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/operator_maintenance_controller.dart';

class OperatorMaintenancePage extends StatefulWidget {
  const OperatorMaintenancePage({Key? key}) : super(key: key);

  @override
  State<OperatorMaintenancePage> createState() => _OperatorMaintenancePageState();
}

class _OperatorMaintenancePageState extends State<OperatorMaintenancePage> {
  late OperatorMaintenanceController controller;

  @override
  void initState() {
    controller = Get.put(OperatorMaintenanceController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
