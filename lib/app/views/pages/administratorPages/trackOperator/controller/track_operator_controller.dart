import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../../base/services/user_location_service.dart';
import '../../../../../../base/viewControllers/user_location_view_controller.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../pages/operator_map_location_page.dart';

class TrackOperatorController extends GetxController {
  late bool _firstLoad;
  late final User operator;
  late TextEditingController operatorNameTextController;
  late TextEditingController operatorDocumentTextController;
  late Rx<UserLocationViewController?> userLocationViewController;
  late RxList<UserLocationViewController> userLocationList;
  late UserLocationService _userLocationService;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;

  TrackOperatorController(this.operator) {
    _initializeVariables();
  }

  @override
  void onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await loadingWithSuccessOrErrorWidget.startAnimation();
    await _initializeTrack();
    super.onInit();
  }

  _initializeVariables() {
    operatorNameTextController = TextEditingController();
    operatorDocumentTextController = TextEditingController();
    operatorNameTextController.text = operator.name;
    operatorDocumentTextController.text = FormatNumbers.stringToCpf(operator.document ?? "");
    _firstLoad = true;
    _userLocationService = UserLocationService();
    userLocationViewController = null.obs;
    userLocationList = <UserLocationViewController>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  openMap() async {
    Get.to(() => OperatorMapLocationPage(
      operator: operator,
    ));
  }

  _initializeTrack() async {
    if(operator.id != null && operator.id != ""){
      if(_firstLoad){
        _firstLoad = false;
        await _localeUser();
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
      Timer.periodic(Duration(seconds: 20), (timer) async {
        await _localeUser();
      });
    }
  }

  _localeUser() async {
    try {
      userLocationViewController = (await _userLocationService.getUserLocation(
        operator.id!,
      )).obs;

      if(userLocationViewController.value != null){
        if(!userLocationList.any((userLocation) => userLocation.id == userLocationViewController.value!.id)) {
          userLocationList.add(userLocationViewController.value!);
        }
        userLocationList.sort((a, b) => a.inclusion!.compareTo(b.inclusion!));
      }
      else{
        throw Exception();
      }

      update(["map_view"]);
    } catch (_) {
      if(loadingWithSuccessOrErrorWidget.isLoading.value) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao localizar o usuário! Tente novamente mais tarde.",
          );
        },
      );
      Get.back();
    }
  }
}