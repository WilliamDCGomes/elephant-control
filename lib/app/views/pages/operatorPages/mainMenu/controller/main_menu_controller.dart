import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utils/get_profile_picture_controller.dart';
import '../../../../../utils/logged_user.dart';

class MainMenuController extends GetxController {
  late RxBool hasPicture;
  late RxBool loadingPicture;
  late RxString profileImagePath;
  late RxString nameProfile;
  late RxString nameInitials;
  late RxString welcomePhrase;
  late RxInt amountPouch;
  late RxInt amountTeddy;
  late DateTime pouchLastChange;
  late DateTime teddyLastChange;
  late SharedPreferences sharedPreferences;

  MainMenuController(){
    _initializeVariables();
    _getNameUser();
    _getWelcomePhrase();
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await GetProfilePictureController.loadProfilePicture(
      loadingPicture,
      hasPicture,
      profileImagePath,
      sharedPreferences,
    );
    super.onInit();
  }

  _initializeVariables(){
    hasPicture = false.obs;
    loadingPicture = true.obs;
    profileImagePath = "".obs;
    nameProfile = "".obs;
    nameInitials = "".obs;
    amountPouch = 6.obs;
    amountTeddy = 250.obs;
    pouchLastChange = DateTime.now();
    teddyLastChange = DateTime.now();
  }

  _getNameUser(){
    LoggedUser.name = "José Paulo";
    LoggedUser.userType = "Operador";
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