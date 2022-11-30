import '../views/pages/widgetsShared/snackbar_tablet_phone_widget.dart';
import '../views/stylePages/app_colors.dart';

class AppCloseController {
  static DateTime? backPushed;
  static bool verifyCloseScreen() {
    DateTime now = DateTime.now();
    if (backPushed == null || (backPushed != null && now.difference(backPushed!) > const Duration(seconds: 2))) {
      backPushed = now;
      SnackbarTabletPhoneWidget(
        warningText: "Aviso",
        informationText: "Pressione novamente para sair",
        backgrondColor: AppColors.orangeColorWithOpacity,
      );
      return false;
    }
    return true;
  }
}