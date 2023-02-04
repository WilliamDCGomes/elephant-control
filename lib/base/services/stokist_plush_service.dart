import '../models/stokistPlush/stokist_plush.dart';
import '../viewControllers/authenticate_response.dart';
import 'base/base_service.dart';

class StokistPlushService extends BaseService {
  Future<AuthenticateResponse?> insertOrRemovePlushies(int plushies) async {
    try {
      httpClient.timeout = Duration(seconds: 30);
      final url = baseUrlApi + 'StokistPlush/InsertOrRemovePlushies';
      final response =
      await super.post(url, null, query: {"plushies": plushies}).timeout(Duration(seconds: 30));
      if (hasErrorResponse(response)) throw Exception();
      return AuthenticateResponse.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  Future<StokistPlush?> getPlushies() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'StokistPlush/GetPlushies';
      final response = await super.get(url, headers: {"Authorization": 'Bearer ' + token});
      if (hasErrorResponse(response)) throw Exception();
      return StokistPlush.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }
}