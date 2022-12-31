import 'package:elephant_control/base/services/interfaces/iuser_service.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../../../base/models/addressInformation/model/address_information.dart';
import '../../../../../../base/models/machine/model/machine.dart';
import '../../../../../../base/models/user/model/user.dart';
import '../../../../../../base/services/consult_cep_service.dart';
import '../../../../../../base/services/interfaces/iconsult_cep_service.dart';
import '../../../../../../base/services/interfaces/imachine_service.dart';
import '../../../../../utils/brazil_address_informations.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';

part 'register_user_machine_controller.g.dart';

class RegisterUserMachineController extends GetxController {
  late RxBool loadingAnimation;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final RxList<User> _users;
  late final IUserService _userService;

  RegisterUserMachineController() {
    _initializeVariables();
  }

  @override
  void onInit() async {
    super.onInit();
  }

  _initializeVariables() {
    loadingAnimation = false.obs;
    _users = <User>[].obs;
    _userService = UserService();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget(
      loadingAnimation: loadingAnimation,
    );
  }

  Future<void> _getAllUserByType() async {
    try {
      loadingAnimation.value = true;
      _users.clear();
      _users.addAll(await _userService.getAllUserByType(UserType.operator));
    } catch (_) {
      _users.clear();
    } finally {
      loadingAnimation.value = false;
    }
  }
}

@JsonSerializable()
class MachineOperator {
  late String UserId;
  late List<Machine> machine;

  MachineOperator({required this.UserId, required this.machine});

  factory MachineOperator.fromJson(Map<String, dynamic> json) => _$MachineOperatorFromJson(json);

  Map<String, dynamic> toJson() => _$MachineOperatorToJson(this);
}
