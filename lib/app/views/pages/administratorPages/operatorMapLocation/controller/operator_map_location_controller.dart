import 'dart:async';
import 'package:elephant_control/base/viewControllers/user_location_view_controller.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../../base/services/user_location_service.dart';

class OperatorMapLocationController extends GetxController {
  late final User operator;
  late Rx<UserLocationViewController?> userLocationViewController;
  late UserLocationService _userLocationService;

  OperatorMapLocationController(this.operator) {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await _initializeTrack();
    super.onInit();
  }

  _initializeVariables() {
    _userLocationService = UserLocationService();
    userLocationViewController = null.obs;
  }

  _initializeTrack() async {
    if(operator.id != null && operator.id != ""){
      Timer.periodic(Duration(seconds: 10), (timer) async {
        try {
          userLocationViewController = (await _userLocationService.getUserLocation(
            operator.id!,
          )).obs;

          print(userLocationViewController.value);
        } catch (_) {
          print(_);
        }
      });
    }
  }
}