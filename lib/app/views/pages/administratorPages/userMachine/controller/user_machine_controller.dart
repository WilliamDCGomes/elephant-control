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
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';

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
      _users.clear();
      _users.addAll(await _machineService.getUsersByMachineId(_machineId));
      _users.sort((a, b) => a.name.compareTo(b.name));
      _users.refresh();
    } catch (e) {

    }
  }

  addUser() async {
    try {
      bool allUsersSelected = false;
      bool doSelection = false;
      await loadingWithSuccessOrErrorWidget.startAnimation();
      List<User> users = await UserService().getAllUserByType(UserType.operator);

      users.removeWhere((element) => _users.any((user) => user.id == element.id));

      await showDialog(
        context: Get.context!,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => DefaultPopupWidget(
            title: "Selecione o usuário",
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButtonWidget(
                widgetCustom: Align(
                  alignment: Alignment.centerLeft,
                  child: CheckboxListTileWidget(
                    radioText: "Selecionar todos",
                    size: 4.h,
                    checked: allUsersSelected,
                    justRead: true,
                    onChanged: () {},
                  ),
                ),
                onTap: () async {
                  setState(() {
                    allUsersSelected = !allUsersSelected;
                    users.forEach((user) {
                      user.selected = allUsersSelected;
                    });
                  });
                },
              ),
              SizedBox(
                height: 40.h,
                child: ListView.builder(
                  itemCount: users.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => TextButtonWidget(
                    widgetCustom: Align(
                      alignment: Alignment.centerLeft,
                      child: CheckboxListTileWidget(
                        radioText: users[index].name,
                        size: 4.h,
                        checked: users[index].selected,
                        justRead: true,
                        onChanged: () {},
                      ),
                    ),
                    onTap: () async {
                      setState(() {
                        users[index].selected = !users[index].selected;
                        if(allUsersSelected && !users[index].selected){
                          allUsersSelected = users[index].selected;
                        }
                        else if(!allUsersSelected && users[index].selected && users.length == 1){
                          allUsersSelected = true;
                        }
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2.h),
                child: ButtonWidget(
                  hintText: "SELECIONAR",
                  textSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  widthButton: double.infinity,
                  onPressed: () {
                    doSelection = true;
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      );

      if(doSelection){
        for(var user in users.where((user) => user.selected).toList()){
          final added = await UserMachineService().createuserMachine(
            UserMachineViewController(
              userId: user.id!,
              machineId: _machineId,
            ),
          );

          if (!added) throw Exception();
        }
      }

      await getUserMachines();

      if (doSelection && users.any((user) => user.selected)) {
        await loadingWithSuccessOrErrorWidget.stopAnimation();
        await showDialog(
          context: Get.context!,
          builder: (context) => InformationPopup(
            warningMessage: "Usuário(s) adicionado(s) com sucesso",
          ),
        );
      }
      else{
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
    }
    catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      await showDialog(
        context: Get.context!,
        builder: (context) => InformationPopup(
          warningMessage: "Não foi possível adicionar o(s) usuário(s)",
        ),
      );
    }
  }

  deleteMachine(User user) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      user.active = false;
      final deleted = await UserMachineService().deleteUserMachine(
        UserMachineViewController(
          userId: user.id!,
          machineId: _machineId,
        ),
      );

      if (!deleted) throw Exception();

      await getUserMachines();
      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
        context: Get.context!,
        builder: (context) => InformationPopup(
          warningMessage: "Usuário deletado com sucesso",
        ),
      );
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      await showDialog(
        context: Get.context!,
        builder: (context) => InformationPopup(
          warningMessage: "Não foi possível deletar o usuário",
        ),
      );
    }
  }
}