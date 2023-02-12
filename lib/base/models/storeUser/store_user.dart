import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
import '../base/elephant_user_core.dart';
import '../base/elephant_core.dart';
part 'store_user.g.dart';

@JsonSerializable()
class StoreUser extends ElephantUserCore {
  late String storeId;
  late String userId;

  StoreUser({
    required this.storeId,
    required this.userId,
  });

  static String get tableName => "STOREUSER";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      StoreId TEXT, UserId TEXT, IncludeUserId TEXT)""";

  factory StoreUser.fromJson(Map<String, dynamic> json) => _$StoreUserFromJson(json);

  Map<String, dynamic> toJson() => _$StoreUserToJson(this);
}
