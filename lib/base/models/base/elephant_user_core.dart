import 'package:elephant_control/base/models/base/elephant_core.dart';

class ElephantUserCore extends ElephantCore {
  late String? includeUserId;

  ElephantUserCore({
    this.includeUserId,
    super.id,
    super.inclusion,
    super.active,
    super.alteration,
  });
}