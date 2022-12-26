import 'package:image_picker/image_picker.dart';
import '../../models/user/model/user.dart';

abstract class IUserService {
  Future<bool> createUser(User user);

  Future<bool> sendNewUser(User newUser);

  Future<bool> updateUser(User user);

  Future<bool> updatePassword(String newPassword);

  Future<bool> resetPassword(String email);

  Future<User?> getUser(String cpf);

  Future<String> getCpf(int studentRa);

  Future<String> getEmail(String userCpf);

  Future<String> getName(String userCpf);

  Future<bool> registerNewUser(String email, String password);

  Future<bool> loggedUser();

  Future<bool> loginUser(String email, String password);

  Future<bool> logoutUser();

  Future<bool> sendUserProfilePicture(XFile image, Function progress);

  Future<String> getUserProfilePicture();

  Future<bool> deleteProfilePicture();
}
