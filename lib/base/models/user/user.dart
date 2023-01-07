import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
part 'user.g.dart';

@JsonSerializable()
class User extends ElephantCore {
  late String name;
  String? tellphone;
  String? document;
  int? balanceMoney;
  DateTime? pouchLastUpdate;
  int? balanceStuffedAnimals;
  DateTime? stuffedAnimalsLastUpdate;
  late UserType type;
  DateTime? birthdayDate;
  late TypeGender gender;
  String? cep;
  String? uf;
  String? city;
  String? address;
  String? number;
  String? district;
  String? complement;
  String? cellphone;
  String? email;
  int? code;

  User({
    required this.name,
    required this.tellphone,
    required this.document,
    required this.balanceMoney,
    required this.balanceStuffedAnimals,
    required this.type,
    required this.pouchLastUpdate,
    required this.stuffedAnimalsLastUpdate,
  });

  User.emptyConstructor() {
    name = "";
    tellphone = "";
    document = "";
    balanceMoney = 0;
    balanceStuffedAnimals = 0;
    type = UserType.operator;
  }

  static String get tableName => "USER";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Inclusion TEXT, Name TEXT, Tellphone TEXT, Document TEXT, Type INTEGER,
      UserName TEXT, NormalizedUserName TEXT, Email TEXT, NormalizedEmail TEXT,
      EmailConfirmed BOOLEAN, PasswordHash TEXT, SecurityStamp TEXT,
      ConcurrencyStamp TEXT, PhoneNumber TEXT, PhoneNumberConfirmed BOOLEAN,
      TwoFactorEnabled BOOLEAN, LockoutEnd TEXT, LockoutEnabled BOOLEAN,
      AccessFailedCount INTEGER, Address TEXT, BirthdayDate TEXT,
      Cellphone TEXT, Cep TEXT, City TEXT, Complement TEXT, Gender INTEGER,
      District TEXT, Number TEXT, Uf TEXT, Code INTEGER)""";

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum UserType {
  @JsonValue(0)
  operator("Operador"),
  @JsonValue(1)
  treasury("Tesouraria"),
  @JsonValue(2)
  stockist("Estoquista"),
  @JsonValue(3)
  admin("Administrativo"),
  @JsonValue(4)
  none("Nenhum");

  final String description;
  const UserType(this.description);
}

enum TypeGender {
  @JsonValue(0)
  masculine,
  @JsonValue(1)
  feminine,
  @JsonValue(2)
  other,
  @JsonValue(4)
  none,
}
