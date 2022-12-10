import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/pages/widgetsShared/popups/information_popup.dart';

class GetProfilePictureController {
  static loadProfilePicture(RxBool loadingPicture, RxBool hasPicture, RxString profileImagePath) async {
    try{
      loadingPicture.value = true;
      profileImagePath.value = "";// await _userService.getUserProfilePicture();
      loadingPicture.value = false;
      hasPicture.value = profileImagePath.value.isNotEmpty;
    }
    catch(_){
      loadingPicture.value = false;
      hasPicture.value = false;
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao atualizar a imagem de perfil.",
          );
        },
      );
    }
  }
}