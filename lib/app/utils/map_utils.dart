import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../views/pages/widgetsShared/popups/information_popup.dart';

class MapUtils {
  static Future<void> openMap(double? latitude, double? longitude) async {
    if(latitude == null || longitude == null){
      return;
    }

    Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    else {
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao abrir o mapa! Verifique se você possui algum aplicativo para visualizar mapas no dispositivo.",
          );
        },
      );
    }
  }
}