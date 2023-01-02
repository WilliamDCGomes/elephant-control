import 'package:elephant_control/base/services/interfaces/iuser_service.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../../../base/models/machine/model/machine.dart';
import '../../../../../../base/models/user/model/user.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';

part 'register_user_machine_controller.g.dart';

class RegisterUserMachineController extends GetxController {
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
    _users = <User>[].obs;
    _userService = UserService();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  Future<void> _getAllUserByType() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _users.clear();
      _users.addAll(await _userService.getAllUserByType(UserType.operator));
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      _users.clear();
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
