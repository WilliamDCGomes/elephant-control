import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import '../../../../../base/models/user/user.dart';
import '../../../../../base/services/user_service.dart';
import '../../administratorPages/registerUsers/page/register_user_page.dart';

class UserController extends GetxController {
  late TextEditingController searchUsers;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final UserService _userService;
  late final RxList<User> _users;

  UserController() {
    searchUsers = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _userService = UserService();
    _users = <User>[].obs;
  }
  @override
  onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await getUsers();
    super.onInit();
  }

  //Getters
  List<User> get users => searchUsers.text.toLowerCase().trim().isEmpty ? _users.where((p0) => p0.active == true).toList() : _users.where((p0) => p0.name.toLowerCase().trim().contains(searchUsers.text.toLowerCase().trim()) && p0.active == true).toList();

  Future<void> getUsers() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _users.clear();
      _users.addAll(await _userService.getAll());
    } catch (e) {
      print(e);
    } finally {
      _users.refresh();
      users.removeWhere((element) => element.id == LoggedUser.id);
      _users.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  void updateList() {
    _users.refresh();
  }

  Future<void> addUserUser() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
    } catch (_) {
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> deleteUser(User user) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      user.active = false;
      final deleted = await _userService.editUser(user);
      if (!deleted) throw Exception();
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Usuário deletado com sucesso"));
    } catch (_) {
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível deletar o usuário"));
    } finally {
      await getUsers();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> resetPassword(User user) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final reseted = await _userService.forgetPassword("Elephant@${DateTime.now().year}", user.document!);
      if (!reseted) throw Exception();
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "A senha de ${user.name} foi resetada com sucesso para\nElephant@${DateTime.now().year}"));
    } catch (_) {
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível resetar a senha"));
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> editUser(User? user) async {
    final _user = await Get.to(() => RegisterUsersPage(
          user: user,
          edit: user != null,
        ));
    if (_user is! User) return;
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final editted = user != null ? await _userService.editUser(_user) : await _userService.createUser(_user);
      if (!editted) throw Exception();
      await getUsers();
      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Usuário ${user != null ? "editado" : "criado"} com sucesso"));
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível  ${user != null ? "editar" : "criar"} o usuário"));
    }
  }
}
