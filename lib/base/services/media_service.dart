import 'package:elephant_control/base/services/base/base_service.dart';
import '../models/media/media.dart';

class MediaService extends BaseService {
  Future<Media?> getMediaById(String id) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'VisitMedia/CreateVisitMedia';
      final response = await get(url, query: {"MediaId": id}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return Media.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }
}
