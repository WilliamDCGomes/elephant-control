import 'package:elephant_control/base/models/base/elephant_core.dart';
import 'package:elephant_control/base/models/base/elephant_user_core.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../context/elephant_context.dart';
part 'user.g.dart';

@JsonSerializable()
class User extends ElephantCore {
  late String name;
  String? tellphone;
  DateTime? birthdayDate;
  String? document;
  late TypeGender gender;
  String? cep;
  String? uf;
  String? city;
  String? address;
  String? number;
  String? district;
  String? complement;
  String? cellphone;
  late UserType type;
  String? email;
  int? code;
  int? balanceStuffedAnimals;
  DateTime? stuffedAnimalsLastUpdate;
  DateTime? pouchLastUpdate;
  int? balanceMoney;
  late String userName;
  String? password;

  @JsonKey(ignore: true)
  late bool selected;

  User({
    required this.name,
    required this.tellphone,
    required this.document,
    required this.balanceMoney,
    required this.balanceStuffedAnimals,
    required this.type,
    required this.pouchLastUpdate,
    required this.stuffedAnimalsLastUpdate,
    required this.userName,
    required this.password,
  }) {
    selected = false;
  }

  User.emptyConstructor() {
    name = "";
    tellphone = "";
    document = "";
    balanceMoney = 0;
    balanceStuffedAnimals = 0;
    type = UserType.operator;
    selected = false;
  }

  static String get tableName => "USER";

  static String get scriptCreateTable => """
      CREATE TABLE IF NOT EXISTS $tableName (${ElephantContext.queryElephantModelBase},
      Name TEXT, Tellphone TEXT, Document TEXT, Type INTEGER,
      UserName TEXT, NormalizedUserName TEXT, Email TEXT, NormalizedEmail TEXT,
      EmailConfirmed BOOLEAN, PasswordHash TEXT, SecurityStamp TEXT,
      ConcurrencyStamp TEXT, PhoneNumber TEXT, PhoneNumberConfirmed BOOLEAN,
      TwoFactorEnabled BOOLEAN, LockoutEnd TEXT, LockoutEnabled BOOLEAN,
      AccessFailedCount INTEGER, Address TEXT, BirthdayDate TEXT,
      Cellphone TEXT, Cep TEXT, City TEXT, Complement TEXT, Gender INTEGER,
      District TEXT, Number TEXT, Uf TEXT, Code INTEGER, BalanceStuffedAnimals INTEGER,
      StuffedAnimalsLastUpdate TEXT, PouchLastUpdate TEXT, BalanceMoney INTEGER, Password TEXT)
      """;

  String get typeName {
    switch (type) {
      case UserType.operator:
        return "Operador";
      case UserType.treasury:
        return "Tesouraria";
      case UserType.stockist:
        return "Estoquista";
      case UserType.admin:
        return "Administrador";
      case UserType.adminPrivileges:
        return "Gerenciamento";
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromJsonRepository(Map<String, dynamic> json) => _$UserFromJson(ElephantUserCore.fromJsonRepository((json)));

  Map<String, dynamic> toJson() => _$UserToJson(this);
  Map<String, dynamic> toJsonRepository() => ElephantUserCore.toJsonCapitalize(_$UserToJson(this));
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
  adminPrivileges("Adm Privilégios");

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
