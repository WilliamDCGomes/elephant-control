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

  static Map<String, dynamic> toJsonCapitalize(Map<String, dynamic> json) =>
      json.map((key, value) => MapEntry(key.toString().capitalize(), value));

  static Map<String, dynamic> fromJsonRepository(Map<String, dynamic> json) =>
      json.map((key, value) => MapEntry(key.toString().uncapitalize(), value));
}

extension ExtensioNString on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String uncapitalize() {
    return "${this[0].toLowerCase()}${substring(1)}";
  }
}
