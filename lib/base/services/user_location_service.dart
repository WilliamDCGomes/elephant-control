import 'package:elephant_control/base/viewControllers/user_location_view_controller.dart';

import 'base/base_service.dart';
import 'interfaces/iuser_location_service.dart';

class UserLocationService extends BaseService implements IUserLocationService {
  @override
  Future<bool> insertUserLocationRepository(UserLocationViewController userLocation) async {
    try {
      final url = baseUrlApi + 'UserLocation/InsertUserLocationRepository';
      final response = await super.post(url, userLocation.toJson());
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }
}
