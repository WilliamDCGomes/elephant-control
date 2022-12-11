import 'package:uuid/uuid.dart';

class ElephantCore {
  late String? id;
  late DateTime? inclusion;
  late DateTime? alteration;
  late bool? active;

  ElephantCore({
    this.id,
    this.inclusion,
    this.alteration,
    this.active,
  }) {
    id ??= const Uuid().v4();
    inclusion ??= DateTime.now();
    alteration ??= DateTime.now();
    active ??= true;
  }
}
