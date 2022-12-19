import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';
part 'machine.g.dart';

@JsonSerializable()
class Machine extends ElephantCore {
  final String name;
  late bool selected;

  Machine({required this.name, this.selected = false});

  factory Machine.fromJson(Map<String, dynamic> json) => _$MachineFromJson(json);

  Map<String, dynamic> toJson() => _$MachineToJson(this);
}
