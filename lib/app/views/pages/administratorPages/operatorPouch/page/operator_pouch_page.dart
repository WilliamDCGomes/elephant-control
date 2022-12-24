import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/operator_pouch_controller.dart';

class OperatorPouchPage extends StatefulWidget {
  const OperatorPouchPage({Key? key}) : super(key: key);

  @override
  State<OperatorPouchPage> createState() => _OperatorPouchPageState();
}

class _OperatorPouchPageState extends State<OperatorPouchPage> {
  late OperatorPouchController controller;

  @override
  void initState() {
    controller = Get.put(OperatorPouchController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
