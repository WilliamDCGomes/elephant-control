import 'package:json_annotation/json_annotation.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  final String userId;
  final String roleId;
  String? name;
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  late bool checked;

  UserRole({required this.userId, required this.roleId, this.name, this.checked = false});

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}
