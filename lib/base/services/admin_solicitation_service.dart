import 'package:elephant_control/base/services/base/base_service.dart';
import '../models/adminSolicitation/admin_solicitation.dart';

class AdminSolicitationService extends BaseService {
  Future<bool> createAdminSolicitation(String visitId, String solicitationUserId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'AdminSolicitation/CreateAdminSolicitation';
      final response = await post(url, null,
          query: {"VisitId": visitId, "SolicitationUserId": solicitationUserId},
          headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> changeStatusAdminSolicitation(String adminSolicitationId, bool accepted) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'AdminSolicitation/ChangeStatusAdminSolicitation';
      final response = await post(url, null,
          query: {"AdminSolicitationId": adminSolicitationId, "Accepted": accepted},
          headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> editAdminSolicitation(AdminSolicitation adminSolicitation) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'AdminSolicitation/EditAdminSolicitation';
      final response = await post(url, adminSolicitation.toJson(), headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }
}
