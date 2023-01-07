import 'package:elephant_control/base/viewControllers/operator_information_viewcontroller.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user/user.dart';
import '../../viewControllers/authenticate_response.dart';
import '../../viewControllers/recall_money_viewcontroller.dart';

abstract class IUserService {
  Future<bool> createUser(User user);

  Future<bool> sendNewUser(User newUser);

  Future<List<User>> getAllUserByType(UserType type);
  Future<List<User>> getUserMachineOperator();

  Future<bool> editUser(User user);

  Future<User?> getUserInformation();
  Future<OperatorInformationViewController?> getOperatorInformation();

  Future<bool> updatePassword(String newPassword);

  Future<bool> forgetPasswordInternal(String password);

  Future<AuthenticateResponse?> authenticate({String? username, String? password});

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
  Future<List<RecallMoneyViewController>> getTreasuryUsersWithMoneyPouchLaunched();
}
