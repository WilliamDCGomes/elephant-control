import 'dart:async';
import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/app/utils/position_util.dart';
import 'package:elephant_control/base/services/user_location_service.dart';
import 'package:elephant_control/base/viewControllers/user_location_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'app.dart';
import 'app/enums/enums.dart';
import 'app/views/stylePages/app_colors.dart';
import 'base/context/elephant_context.dart';
import 'base/models/user/user.dart';
import 'flavors.dart';
import 'package:collection/collection.dart';

buildFlavor(Flavor flavor) async {
  F.appFlavor = flavor;
  WidgetsFlutterBinding.ensureInitialized();
  Map<int, Color> color = {
    50: AppColors.defaultColor,
    100: AppColors.defaultColor,
    200: AppColors.defaultColor,
    300: AppColors.defaultColor,
    400: AppColors.defaultColor,
    500: AppColors.defaultColor,
    600: AppColors.defaultColor,
    700: AppColors.defaultColor,
    800: AppColors.defaultColor,
    900: AppColors.defaultColor,
  };
  MaterialColor colorCustom = MaterialColor(0XFF1E4767, color);
  await ElephantContext().initializeDatabase();
  sendLocation();
  runApp(App(color: colorCustom));
}

void sendLocation() async {
  final userLocationService = UserLocationService();
  Timer.periodic(Duration(seconds: 3), (timer) async {
    try {
      if (LoggedUser.userType != UserType.operator) return;
      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) return;
      final currentLocation = await PositionUtil.determinePosition();
      if (currentLocation == null) return;

      final latitude = currentLocation.latitude.toString();
      final longitude = currentLocation.longitude.toString();
      List<Placemark> placemarks = await placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);
      if (LoggedUser.id.isEmpty) return;

      final userLocation = UserLocationViewController(
        longitude: longitude,
        latitude: latitude,
        userLocationId: LoggedUser.id,
        address: placemarks.firstWhereOrNull((element) => element.street?.isNotEmpty ?? false)?.street,
        cep: placemarks.firstWhereOrNull((element) => element.postalCode?.isNotEmpty ?? false)?.postalCode,
        city: placemarks.firstWhereOrNull((element) => element.locality?.isNotEmpty ?? false)?.locality ??
            placemarks
                .firstWhereOrNull((element) => element.subAdministrativeArea?.isNotEmpty ?? false)
                ?.subAdministrativeArea,
        district: placemarks.firstWhereOrNull((element) => element.subLocality?.isNotEmpty ?? false)?.subLocality,
        uf: placemarks.firstWhereOrNull((element) => element.administrativeArea?.isNotEmpty ?? false)?.administrativeArea,
      );
      await userLocationService.insertUserLocationRepository(userLocation);
    } catch (_) {
      print(_);
    }
  });
}
