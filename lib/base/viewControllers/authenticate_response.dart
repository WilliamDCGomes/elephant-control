import 'package:elephant_control/base/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authenticate_response.g.dart';

@JsonSerializable()
class AuthenticateResponse {
  final String? id;
  final String? name;
  final String? login;
  final DateTime? expirationDate;
  final String? token;
  final UserType? userType;
  final bool success;

  AuthenticateResponse({
    required this.id,
    required this.name,
    required this.login,
    required this.expirationDate,
    required this.token,
    required this.userType,
    required this.success,
  });

  factory AuthenticateResponse.fromJson(Map<String, dynamic> json) => _$AuthenticateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticateResponseToJson(this);
}
