import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/default_popup_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:elephant_control/base/services/user_machine_service.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:elephant_control/base/viewControllers/user_machine_viewcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/user/user.dart';

class UserMachineController extends GetxController {
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final MachineService _machineService;
  late final RxList<User> _users;
  late final String _machineId;

  UserMachineController(this._machineId) {
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _machineService = MachineService();
    _users = <User>[].obs;
  }
  @override
  onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await getUserMachines();
    super.onInit();
  }

  //Getters
  List<User> get users => _users.where((p0) => p0.active == true).toList();

  Future<void> getUserMachines() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _users.clear();
      _users.addAll(await _machineService.getUsersByMachineId(_machineId));
    } catch (e) {
      print(e);
    } finally {
      _users.sort((a, b) => a.name.compareTo(b.name));
      _users.refresh();
      loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> addUser() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final users = await UserService().getAllUserByType(UserType.operator);
      users.removeWhere((element) => _users.any((user) => user.id == element.id));
      int? indexSelecionado;
      await showDialog(
          context: Get.context!,
          builder: (context) => DefaultPopupWidget(
                title: "Selecione o usuário",
                children: [
                  SizedBox(
                    height: 40.h,
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) => TextButtonWidget(
                        widgetCustom: Text(users[index].name),
                        onTap: () async {
                          indexSelecionado = index;
                          Get.back();
                        },
                      ),
                    ),
                  ),
                ],
              ));
      if (indexSelecionado != null) {
        final user = users[indexSelecionado!];
        final added = await UserMachineService().createuserMachine(UserMachineViewController(userId: user.id!, machineId: _machineId));
        if (!added) throw Exception();
        await getUserMachines();
        await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Usuário adicionado com sucesso"));
      }
    } catch (_) {
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> deleteMachine(User user) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      user.active = false;
      final deleted = await UserMachineService().deleteUserMachine(UserMachineViewController(userId: user.id!, machineId: _machineId));
      if (!deleted) throw Exception();
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Usuário deletado com sucesso"));
    } catch (_) {
      await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível deletar o usuário"));
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      await getUserMachines();
    }
  }

  // Future<void> editMachine(Machine machine) async {
  //   final _machine = await Get.to(() => RegisterMachinePage(machine: machine));
  //   if (_machine is! Machine) return;
  //   try {
  //     await loadingWithSuccessOrErrorWidget.startAnimation();
  //     final editted = await _machineService.createOrUpdateMachine(machine);
  //     if (!editted) throw Exception();
  //     await getMachines();
  //     await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Máquina editada com sucesso"));
  //   } catch (_) {
  //     await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível editar a máquina"));
  //   } finally {
  //     await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
  //   }
  // }
}
