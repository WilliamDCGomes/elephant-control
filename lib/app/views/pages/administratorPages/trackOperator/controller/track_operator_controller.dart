import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../utils/format_numbers.dart';

class TrackOperatorController extends GetxController {
  late final User operator;
  late TextEditingController operatorNameTextController;
  late TextEditingController operatorDocumentTextController;

  TrackOperatorController(this.operator) {
    _initializeVariables();
  }

  _initializeVariables() {
    operatorNameTextController = TextEditingController();
    operatorDocumentTextController = TextEditingController();
    operatorNameTextController.text = operator.name;
    operatorDocumentTextController.text = FormatNumbers.stringToCpf(operator.document ?? "");
  }
}