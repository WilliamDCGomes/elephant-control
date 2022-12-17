import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../viewControllers/authenticate_response.dart';
import 'base/base_service.dart';
import 'interfaces/iuser_service.dart';

class UserService extends BaseService implements IUserService {
  Future<AuthenticateResponse?> authenticate({String? username, String? password}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      username ??= sharedPreferences.getString('Login');
      password ??= sharedPreferences.getString('Senha');
      if (username == null || password == null) throw Exception();
      final url = baseUrlApi + 'User/Authenticate';
      final response = await super.post(url, null, query: {"username": username, "password": password}).timeout(Duration(seconds: 30));
      if (hasErrorResponse(response)) throw Exception();
      return AuthenticateResponse.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  Future<User?> getUserInformation() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'User/GetUserInformation';
      final response = await super.get(url, headers: {"Authorization": 'Bearer ' + token});
      return User.fromJson(response.body);
    } catch (_) {
      return null;
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
}
