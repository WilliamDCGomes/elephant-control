import 'package:elephant_control/base/models/roles/role.dart';
import 'package:elephant_control/base/models/roles/user_role.dart';
import 'package:elephant_control/base/viewControllers/operator_information_viewcontroller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user/user.dart';
import '../viewControllers/authenticate_response.dart';
import '../viewControllers/recall_money_viewcontroller.dart';
import 'base/base_service.dart';
import 'interfaces/iuser_service.dart';

class UserService extends BaseService implements IUserService {
  Future<AuthenticateResponse?> authenticate({String? username, String? password}) async {
    try {
      httpClient.timeout = Duration(seconds: 30);
      final sharedPreferences = await SharedPreferences.getInstance();
      username ??= sharedPreferences.getString('user_logged');
      password ??= sharedPreferences.getString('password');
      if (username == null || password == null) throw Exception();
      final url = baseUrlApi + 'User/Authenticate';
      final response =
          await super.post(url, null, query: {"username": username, "password": password}).timeout(Duration(seconds: 30));
      if (hasErrorResponse(response)) throw Exception();
      return AuthenticateResponse.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  Future<User?> getUserById(String userId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetUserById';
      final response = await super.get(url, query: {"UserId": userId}, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return User.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  Future<User?> getUserInformation() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetUserInformation';
      final response = await super.get(url, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return User.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  Future<List<User>> getAllUserByType(UserType type) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetAllUserByType';
      String typeUser = type == UserType.operator ? "Operator" : "Treasury";
      final response = await super.get(url, query: {"Type": typeUser}, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<User>((e) => User.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<User>> getAll() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetAll';
      final response = await super.get(url, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<User>((e) => User.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> createUser(User user) async {
    try {
      final url = baseUrlApi + 'User/CreateUser';
      final response = await super.post(url, user.toJson());
      if (hasErrorResponse(response)) throw Exception();
      return response.body != null;
    } catch (_) {
      return false;
    }
  }

  Future<bool> editUser(User user) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/EditUser';
      final response = await super.post(url, user.toJson(), headers: {"Authorization": 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (e) {
      return false;
    }
  }

  Future<bool> forgetPassword(String password, String documemnt) async {
    try {
      final url = baseUrlApi + 'User/ForgetPassword';
      final response = await super.post(url, null, query: {"Password": password, "Document": documemnt});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> forgetPasswordInternal(String password) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/ForgetPasswordInternal';
      final response =
          await super.post(url, null, query: {"Password": password}, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendNewUser(User newUser) async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<User?> getUser(String cpf) async {
    try {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String> getCpf(int studentRa) async {
    try {
      return "";
    } catch (_) {
      return "";
    }
  }

  Future<String> getEmail(String userCpf) async {
    try {
      return "";
    } catch (_) {
      return "";
    }
  }

  Future<String> getName(String userCpf) async {
    try {
      return "";
    } catch (_) {
      return "";
    }
  }

  Future<bool> registerNewUser(String email, String password) async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> loggedUser() async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> logoutUser() async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendUserProfilePicture(XFile image, Function progress) async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> getUserProfilePicture() async {
    try {
      return "";
    } catch (_) {
      return "";
    }
  }

  Future<bool> deleteProfilePicture() async {
    try {
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<User>> getUserMachineOperator() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetUserMachineOperator';
      final response = await super.get(url, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<User>((e) => User.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<OperatorInformationViewController?> getOperatorInformation() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetOperatorInformation';
      final response = await super.get(url, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return OperatorInformationViewController.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  Future<List<RecallMoneyViewController>> getTreasuryUsersWithMoneyPouchLaunched() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetTreasuryUsersWithMoneyPouchLaunched';
      final response = await super.get(url, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<RecallMoneyViewController>((e) => RecallMoneyViewController.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> addOrRemoveBalanceStuffedAnimalsOperator(
      String userOperatorId, int balanceStuffedAnimals, String observation, bool addStuffedAnimals) async {
    try {
      final url = baseUrlApi + 'User/AddOrRemoveBalanceStuffedAnimalsOperator';
      final response = await super.post(url, null, query: {
        "UserOperatorId": userOperatorId,
        "BalanceStuffedAnimals": balanceStuffedAnimals.toString(),
        "Observation": observation,
        "AddStuffedAnimals": addStuffedAnimals.toString(),
      });
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> AddOrRemoveBalanceStuffedAnimalsJustOperator(
      String userOperatorId, int balanceStuffedAnimals, String observation, bool addStuffedAnimals) async {
    try {
      final url = baseUrlApi + 'User/AddOrRemoveBalanceStuffedAnimalsJustOperator';
      final response = await super.post(url, null, query: {
        "UserOperatorId": userOperatorId,
        "BalanceStuffedAnimals": balanceStuffedAnimals.toString(),
        "Observation": observation,
        "AddStuffedAnimals": addStuffedAnimals.toString(),
      });
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> addOrRemoveRoleByUserId(UserRole userRole) async {
    try {
      final url = baseUrlApi + 'User/AddOrRemoveRoleByUserId';
      final response = await super.post(url, null, query: {"UserId": userRole.userId, "RoleId": userRole.roleId});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<Role>> getRoles() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetRoles';
      final response = await super.get(url, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<Role>((e) => Role.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<UserRole>> getUserRoles(String userId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetUserRoles';
      final response = await super.get(url, query: {"UserId": userId}, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<UserRole>((e) => UserRole.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
