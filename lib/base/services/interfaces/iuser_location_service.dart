import '../../viewControllers/user_location_view_controller.dart';

abstract class IUserLocationService {
  Future<bool> insertUserLocationRepository(UserLocationViewController userLocation);
}
