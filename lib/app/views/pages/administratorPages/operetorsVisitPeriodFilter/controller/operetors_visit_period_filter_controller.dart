import 'package:elephant_control/base/services/user_service.dart';
import 'package:elephant_control/base/services/visit_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../../base/services/interfaces/iuser_service.dart';
import '../../../../../../base/services/interfaces/ivisit_service.dart';
import '../../../../../../base/viewControllers/visits_of_operators_viewcontroller.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/checkbox_list_tile_widget.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/default_popup_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../../../widgetsShared/text_button_widget.dart';

class OperatorsVisitsPeriodFilterController extends GetxController {
  late DateTime initialDateFilter;
  late DateTime finalDateFilter;
  late RxInt visitsQuantity;
  late RxBool screenLoading;
  late RxString userSelected;
  late RxList<String> usersName;
  late RxList<User> users;
  late RxList<VisitOfOperatorsViewController> operatorVisitList;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late IUserService _userService;
  late IVisitService _visitService;
  late RxBool showInfos;

  OperatorsVisitsPeriodFilterController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await _getUsers();
    super.onInit();
  }

  _initializeVariables() {
    initialDateFilter = DateTime.now();
    finalDateFilter = DateTime.now();
    screenLoading = true.obs;
    visitsQuantity = 0.obs;
    userSelected = "".obs;
    usersName = <String>[].obs;
    users = <User>[].obs;
    operatorVisitList = <VisitOfOperatorsViewController>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _userService = UserService();
    _visitService = VisitService();
    showInfos = true.obs;
  }

  _getUsers() async {
    try {
      users.value = await _userService.getAllUserByType(UserType.operator);

      userSelected.value = "Todos os Operadores";

      users.sort((a, b) => a.name.compareTo(b.name));
      for (var i = 0; i < users.length; i++) {
        users[i].selected = true;
        usersName.add(users[i].name);
        if (i + 1 < users.length) {
          try {
            if (users[i].name.startsWith(users[i + 1].name)) {
              late List<String> userName;
              userName = users[i].name.trim().split(' ');
              if (userName.length > 1) {
                users[i + 1].name += " - ${int.parse(userName.last) + 1}";
              } else {
                users[i].name += " - 1";
                users[i + 1].name += " - 2";
              }
            }
          } catch (_) {}
        }
      }

      await getVisitsUser(loadingEnabled: false);

      screenLoading.value = false;
    } catch (_) {
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro buscar os usuários! Tente novamente mais tarde.",
          );
        },
      );
      Get.back();
    }
  }

  selectedUsers() async {
    bool allUsersSelected = true;
    await showDialog(
      context: Get.context!,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DefaultPopupWidget(
          title: "Selecione as máquinas",
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButtonWidget(
              widgetCustom: Align(
                alignment: Alignment.centerLeft,
                child: CheckboxListTileWidget(
                  radioText: "Selecionar todas",
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
                  Get.back();
                  if(users.where((element) => element.selected).length == 1){
                    userSelected.value = users.firstWhere((element) => element.selected).name;
                  }
                  else if(users.where((element) => element.selected).length == users.length){
                    userSelected.value = "Todos os Operadores";
                  }
                  else if(users.where((element) => element.selected).length > 1){
                    userSelected.value = "Alguns Operadores";
                  }
                  else{
                    userSelected.value = "Nenhum Operador";
                  }

                  setState(() {
                    users.sort((a, b) => a.name.compareTo(b.name));
                    users.sort((a, b) => b.selected.toString().compareTo(a.selected.toString()));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getVisitsUser({bool loadingEnabled = true}) async {
    try {
      visitsQuantity.value = 0;
      if(!users.any((element) => element.selected)){
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InformationPopup(
              warningMessage: "Selecione pelo menos um operador para visualizar as visitas.",
            );
          },
        );
        return;
      }
      else if (loadingEnabled) {
        await loadingWithSuccessOrErrorWidget.startAnimation();
      }

      var allSelectedUsers = users.where((element) => element.selected);

      List<String>? usersIdsSelected = <String>[];

      for(var machine in allSelectedUsers){
        if(machine.id != null){
          usersIdsSelected.add(machine.id!);
        }
      }

      //Para pegar tds os ids. Passar todos eles quebra o json
      if(usersIdsSelected.length == users.length){
        usersIdsSelected = null;
      }
      else if(usersIdsSelected.length > 20){
        if (loadingEnabled) {
          await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
        }
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return InformationPopup(
              warningMessage: "Não é possível passar mais de 20 operadores ao mesmo tempo para filtrar.\nQuantidade adicionada: " + (usersIdsSelected != null ? FormatNumbers.scoreIntNumber(usersIdsSelected.length) : "0"),
            );
          },
        );
        return;
      }

      operatorVisitList.value = (await _visitService.getVisitsOfOperatorsByUserIdAndPeriod(
        usersIdsSelected,
        initialDateFilter,
        finalDateFilter,
      ))
        ..sort((a, b) => (a.machineName).compareTo(b.machineName))
        ..sort((a, b) {
          if (a.hasIncident || b.hasIncident) {
            if (a.hasIncident && b.hasIncident) {
              return 0;
            } else if (a.hasIncident) {
              return -1;
            } else {
              return 1;
            }
          } else {
            return 0;
          }
        })
        ..sort((a, b) => (a.status?.index ?? 10).compareTo(b.status?.index ?? 10));
      visitsQuantity.value = operatorVisitList.length;
      update(["visit-list"]);
      if (loadingEnabled) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
    } catch (_) {
      if (loadingEnabled) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      }
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro buscar as visitas do operador! Tente novamente mais tarde.",
          );
        },
      );
    }
  }

  initialFilterPerDate() async {
    DateTime auxDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA DATA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialDate: initialDateFilter,
      firstDate: DateTime(auxDate.year - 2, auxDate.month, auxDate.day),
      lastDate: auxDate,
    );

    if (picked != null && picked != initialDateFilter) {
      initialDateFilter = picked;
      update(["initial-date-filter"]);
    }
  }

  finalFilterPerDate() async {
    DateTime auxDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      helpText: "SELECIONE UMA DATA",
      confirmText: "Selecionar",
      cancelText: "Cancelar",
      initialDate: finalDateFilter,
      firstDate: DateTime(auxDate.year - 2, auxDate.month, auxDate.day),
      lastDate: auxDate,
    );

    if (picked != null && picked != finalDateFilter) {
      finalDateFilter = picked;
      update(["final-date-filter"]);
    }
  }
}
