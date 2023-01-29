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
import '../pages/operator_map_location_page.dart';

class TrackOperatorController extends GetxController {
  late bool _firstLoad;
  late bool isInMapScreen;
  late final User operator;
  late TextEditingController operatorNameTextController;
  late TextEditingController operatorDocumentTextController;
  late UserLocationViewController? userLocationViewController;
  late ScrollController scrollController;
  late MapController mapController;
  late RxList<UserLocationViewController> userLocationList;
  late UserLocationService _userLocationService;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late Timer timer;
  late OperatorMapLocationPageState operatorMapLocationPageState;

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
    scrollController = ScrollController();
    mapController = MapController();
    _firstLoad = true;
    isInMapScreen = false;
    _userLocationService = UserLocationService();
    userLocationViewController = null;
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
        await _localeUser(fistLoad: true);
        if(loadingWithSuccessOrErrorWidget.isLoading.value) {
          await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
        }
        _firstLoad = false;
      }
      timer = Timer.periodic(Duration(seconds: 3), (timer) async {
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

        if(isInMapScreen){
          _animatedMapMove(
            LatLng(
              userLocationViewController!.latitudeValue,
              userLocationViewController!.longitudeValue,
            ),
          );
          update(["map-list"]);
        }
      }
      else{
        throw Exception();
      }

      if(!fistLoad){
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    } catch (_) {
      if(loadingWithSuccessOrErrorWidget.isLoading.value) {
        await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
      }
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

  void _animatedMapMove(LatLng destLocation) {
    final latTween = Tween<double>(
      begin: mapController.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: mapController.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: mapController.zoom,
      end: 18,
    );

    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: operatorMapLocationPageState,
    );

    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      mapController.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}