import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../base/elephant_core.dart';

part 'store.g.dart';

@JsonSerializable()
class Store extends ElephantUserCore {
  late String name;
  late String description;

  Store({
    required this.name,
    required this.description,
  });

  static String get tableName => "STORE";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Name TEXT, Description TEXT, IncludeUserId TEXT)""";

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
