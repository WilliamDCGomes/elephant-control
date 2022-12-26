import 'package:flutter/material.dart';
import 'app.dart';
import 'app/enums/enums.dart';
import 'app/views/stylePages/app_colors.dart';
import 'flavors.dart';

buildFlavor(Flavor flavor) async {
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
  F.appFlavor = flavor;
  runApp(
    App(color: colorCustom)
  );
}