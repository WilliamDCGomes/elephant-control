import 'package:elephant_control/base/models/visit.dart';
import 'package:elephant_control/base/models/visit_media.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/visit_list_viewcontroller.dart';

class VisitService extends BaseService {
  Future<bool> createVisit(Visit visit) async {
    try {
      final url = baseUrlApi + 'Visit/CreateVisit';
      final data = visit.toJson();
      final response = await post(url, data);
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<List<VisitListViewController>> getVisitsByUserId() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetVisitsByUserId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => VisitListViewController.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

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
}
