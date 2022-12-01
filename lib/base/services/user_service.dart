import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import 'interfaces/iuser_service.dart';

class UserService implements IUserService {
  Future<bool> sendNewUser(Users newUser) async {
    try {

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateUser(Users user) async {
    try {

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Users?> getUser(String cpf) async {
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
    try{

      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    try{

      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try{

      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<bool> loggedUser() async {
    try{

      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try{

      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<bool> logoutUser() async {
    try{

      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<bool> sendUserProfilePicture(XFile image, Function progress) async {
    try{

      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<String> getUserProfilePicture() async {
    try{

      return "";
    }
    catch(_){
      return "";
    }
  }

  Future<bool> deleteProfilePicture() async {
    try{

      return true;
    }
    catch(_){
      return false;
    }
  }
}