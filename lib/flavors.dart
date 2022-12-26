import 'package:flutter/material.dart';
import 'app/enums/enums.dart';
import 'app/views/pages/sharedPages/initialPage/page/initial_page.dart';

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.HMLG:
        return 'Elephant Control HMLG';
      case Flavor.PROD:
        return 'Elephant Control';
      default:
        return 'Elephant Control DEV';
    }
  }

  static bool get isDev => F.appFlavor == Flavor.DEV;
  static bool get isHmlg => F.appFlavor == Flavor.HMLG;
  static bool get isProd => F.appFlavor == Flavor.PROD;

  static String get baseURL {
    switch (appFlavor) {
      case Flavor.HMLG:
        return 'https://elephantapiprod.azurewebsites.net/api/';
      case Flavor.PROD:
        return 'https://elephantapiprod.azurewebsites.net/api/';
        //return 'http://192.168.1.10:5002/api/';
      default:
        return 'https://elephantapiprod.azurewebsites.net/api/';
    }
  }

  static Widget get initialScreen {
    switch (appFlavor) {
      case Flavor.HMLG:
        return InitialPage();
      case Flavor.PROD:
        return InitialPage();
      default:
        return InitialPage();
    }
  }
}
