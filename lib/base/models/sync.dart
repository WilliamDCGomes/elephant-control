import 'package:elephant_control/base/models/base/elephant_core.dart';

class Sync extends ElephantCore {
  String? service;
  String? method;
  bool? success;
  String? message;
  late DateTime start;
  int? fullTime;

  Sync({
    this.service,
    this.method,
    this.success,
    this.message,
    required this.start,
    this.fullTime,
    DateTime? change,
  });
}
