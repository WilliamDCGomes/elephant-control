import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends ElephantCore {
  late String? name;
  late String? tellphone;
  late String? document;
  late double? balanceMoney;
  late double? balanceStuffesAnimals;
  late UserType type;

  User({
    required this.name,
    required this.tellphone,
    required this.document,
    required this.balanceMoney,
    required this.balanceStuffesAnimals,
    required this.type,
  });

  User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum UserType {
  @JsonValue(0)
  operator,
  @JsonValue(1)
  treasury,
  @JsonValue(2)
  admin,
}
