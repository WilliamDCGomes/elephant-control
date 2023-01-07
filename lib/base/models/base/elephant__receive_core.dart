import 'package:uuid/uuid.dart';

class ElephantReceiveCore {
  late String? id;
  late DateTime? inclusion;
  late bool? active;

  ElephantReceiveCore({
    this.id,
    this.inclusion,
    this.active,
  }) {
    id ??= const Uuid().v4();
    inclusion ??= DateTime.now();
    active ??= true;
  }
}