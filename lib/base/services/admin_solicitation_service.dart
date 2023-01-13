import 'package:elephant_control/base/models/user/user.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/add_money_pouch_viewcontroller.dart';
import 'package:elephant_control/base/viewControllers/visit_list_viewcontroller.dart';
import '../models/adminSolicitation/admin_solicitation.dart';
import '../viewControllers/money_pouch_viewcontroller.dart';
import '../viewControllers/safe_box_financial_viewcontroller.dart';
import '../viewControllers/visits_of_operators_viewcontroller.dart';
import 'interfaces/ivisit_service.dart';

class AdminSolicitationService extends BaseService {
  Future<bool> createAdminSolicitation(String visitId, String solicitationUserId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'AdminSolicitation/CreateAdminSolicitation';
      final response = await post(url, null, query: {"VisitId": visitId, "SolicitationUserId": solicitationUserId}, headers: {'Authorization': 'Bearer ${token}'});
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
      final response = await post(url, null, query: {"AdminSolicitationId": adminSolicitationId, "Accepted": accepted}, headers: {'Authorization': 'Bearer ${token}'});
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
