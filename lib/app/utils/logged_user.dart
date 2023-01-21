import 'package:elephant_control/base/models/roles/user_role.dart';

import '../../base/models/user/user.dart';

class LoggedUser {
  static String id = "";
  static UserType? userType;
  static String userTypeName = "";
  static String name = "";
  static String nameInitials = "";
  static String nameAndLastName = "";
  static String birthdate = "";
  static String cpf = "";
  static String gender = "";
  static String cep = "";
  static String uf = "";
  static String city = "";
  static String street = "";
  static String? houseNumber = "";
  static String neighborhood = "";
  static String complement = "";
  static String? phone = "";
  static String? cellPhone = "";
  static String email = "";
  static String password = "";
  static DateTime? includeDate;
  static int initialAmountTeddy = 0;
  static int? balanceMoney;
  static DateTime? pouchLastUpdate;
  static int? balanceStuffedAnimals;
  static DateTime? stuffedAnimalsLastUpdate;
  static List<UserRole> roles = [];
  static List<String> get nameRoles => roles.where((element) => element.name != null).map((e) => e.name!).toList();
}
