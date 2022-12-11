import 'package:elephant_control/base/models/visit.dart';
import 'package:elephant_control/base/services/base/base_service.dart';

class VisitService extends BaseService {
  Future<bool> createVisit(Visit visit) async {
    try {
      final url = super.baseUrlApi + '/api/Visit/CreateVisit';
      final response = await super.post(url, visit.toJson());
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }
}
