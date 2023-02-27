import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'last_machines_visit_viewcontroller.g.dart';

@JsonSerializable()
class LastMachinesVisitViewController {
  late String machineName;
  late DateTime inclusion;

  LastMachinesVisitViewController();

  factory LastMachinesVisitViewController.fromJson(Map<String, dynamic> json) =>
      _$LastMachinesVisitViewControllerFromJson(json);

  Map<String, dynamic> toJson() => _$LastMachinesVisitViewControllerToJson(this);
}
