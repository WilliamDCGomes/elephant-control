import 'dart:io';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../views/pages/widgetsShared/popups/information_popup.dart';

class PictureUtil {
  static openImage(XFile? xfile){
    if(xfile != null){
      showImageViewer(
        Get.context!,
        Image.memory(
          File(xfile.path).readAsBytesSync(),
        ).image,
      );
    }
    else{
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Não é possível abrir a imagem.",
          );
        },
      );
    }
  }
}