import '../../models/user/user.dart';
import '../../viewControllers/money_pouch_get_viewcontroller.dart';

abstract class IMoneyPouchService {
  Future<MoneyPouchGetViewController?> getPouchInformation(String userId);

  Future<MoneyPouchGetViewController?> getAllPouchInformation(UserType type);
}