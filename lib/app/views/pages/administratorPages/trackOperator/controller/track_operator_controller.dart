import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../../../base/services/user_location_service.dart';
import '../../../../../../base/viewControllers/user_location_view_controller.dart';
import '../../../../../utils/format_numbers.dart';
import '../../../widgetsShared/loading_with_success_or_error_widget.dart';
import '../../../widgetsShared/popups/information_popup.dart';
import '../page/track_operator_page.dart';

class TrackOperatorController extends GetxController {
  late bool _firstLoad;
  late RxBool showMap;
  late final User operator;
  late TextEditingController operatorNameTextController;
  late TextEditingController operatorDocumentTextController;
  late UserLocationViewController? userLocationViewController;
  late ScrollController scrollController;
  late MapController mapController;
  late RxList<UserLocationViewController> userLocationList;
  late UserLocationService _userLocationService;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late TrackOperatorPageState _trackOperatorPageState;

  TrackOperatorController(this.operator, this._trackOperatorPageState) {
    _initializeVariables();
  }

  _initializeVariables() {
    showMap = false.obs;
    operatorNameTextController = TextEditingController();
    operatorDocumentTextController = TextEditingController();
    operatorNameTextController.text = operator.name;
    operatorDocumentTextController.text = FormatNumbers.stringToCpf(operator.document ?? "");
    scrollController = ScrollController();
    mapController = MapController();
    _firstLoad = true;
    _userLocationService = UserLocationService();
    userLocationViewController = null;
    userLocationList = <UserLocationViewController>[].obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
  }

  initializeVariableAsync() async {
    await Future.delayed(Duration(milliseconds: 200));
    await loadingWithSuccessOrErrorWidget.startAnimation();
    await _initializeTrack();
  }

  openMap() async {
    if(userLocationList.isNotEmpty){
      showMap.value = true;
    }
    else{
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Não é possível abrir o mapa, pois não há nenhuma localização para mostrar!",
          );
        },
      );
    }
  }

  _initializeTrack() async {
    if(operator.id != null && operator.id != ""){
      if(_firstLoad){
        await _localeUser(fistLoad: true);
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
        _firstLoad = false;
      }
      await Future.delayed(Duration(milliseconds: 200));
      Timer.periodic(Duration(seconds: 3), (timer) async {
        await _localeUser();
      });
    }
  }

  _localeUser({bool fistLoad = false}) async {
    try {
      userLocationViewController = await _userLocationService.getUserLocation(
        operator.id!,
      );

      if(userLocationViewController != null){
        if(!userLocationList.any((userLocation) => userLocation.streetName == userLocationViewController!.streetName)) {
          userLocationList.add(userLocationViewController!);
        }

        userLocationList.sort((a, b) => a.inclusion!.compareTo(b.inclusion!));

        if(showMap.value){
          _trackOperatorPageState.animatedMapMove(
            LatLng(
              userLocationViewController!.latitudeValue,
              userLocationViewController!.longitudeValue,
            ),
          );
          update(["map-list"]);
        }
        else if(!fistLoad){
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        }
      }
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      if(_firstLoad){
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

  Future<bool> returnScreen() async{
    if(showMap.value){
      showMap.value = false;
      return false;
    }
    return true;
  }

  titleScreenTapped() {
    if(showMap.value){
      showMap.value = false;
    }
    else{
      Get.back();
    }
  }
}