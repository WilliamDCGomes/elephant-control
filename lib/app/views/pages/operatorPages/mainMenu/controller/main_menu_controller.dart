import 'package:get/get.dart';
import '../../../../../utils/logged_user.dart';

class MainMenuController extends GetxController {
  late RxBool hasPicture;
  late RxBool loadingPicture;
  late RxString profileImagePath;
  late RxString nameProfile;
  late RxString nameInitials;
  late RxString welcomePhrase;

  MainMenuController(){
    _initializeVariables();
    _getNameUser();
    _getWelcomePhrase();
  }

  _initializeVariables(){
    hasPicture = false.obs;
    loadingPicture = true.obs;
    profileImagePath = "".obs;
    nameProfile = "".obs;
    nameInitials = "".obs;
  }

  _getNameUser(){
    var names = LoggedUser.name.trim().split(" ");

    if(names.isNotEmpty && names.first != ""){
      nameProfile.value = names[0];
      LoggedUser.nameAndLastName = names[0];
      nameInitials.value = nameProfile.value[0];
      if(names.length > 1 && names.last != ""){
        nameInitials.value += names.last[0];
        LoggedUser.nameAndLastName += " ${names.last}";
      }
      LoggedUser.nameInitials = nameInitials.value;
    }
  }

  _getWelcomePhrase() {
    int currentHour = DateTime.now().hour;
    if(currentHour >= 0 && currentHour < 12)
      welcomePhrase = "Bom dia!".obs;
    else if(currentHour >= 12 && currentHour < 18)
      welcomePhrase = "Boa tarde!".obs;
    else
      welcomePhrase = "Boa noite!".obs;
  }
}