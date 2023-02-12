import 'package:elephant_control/base/models/visitMedia/visit_media.dart';
import 'package:elephant_control/base/services/base/base_service.dart';

class VisitMediaService extends BaseService {
  Future<bool> createVisitMedia(List<VisitMedia> visitsMedia) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'VisitMedia/CreateVisitMedia';
      for (var element in visitsMedia) {
        final data = element.toJson();
        final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateVisitMedia(List<VisitMedia> visitsMedia) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'VisitMedia/UpdateVisitMedia';
      for (var element in visitsMedia) {
        final data = element.toJson();
        final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'}).timeout(Duration(minutes: 2));
        if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<VisitMedia>> getVisitMediaByVisitId(String visitId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'VisitMedia/GetVisitMediaByVisitId';
      final response = await get(url, query: {"VisitId": visitId}, headers: {'Authorization': 'Bearer ${token}'}).timeout(Duration(minutes: 2));
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visitMedia) => VisitMedia.fromJson(visitMedia)).toList();
    } catch (_) {
      return [];
    }
  }
}
