import 'package:elephant_control/base/services/base/base_service.dart';
import '../viewControllers/report_viewcontroller.dart';

class ReportService extends BaseService {
  Future<ReportViewController?> getDefaultReport(DateTime beginDate, DateTime endDate, List<String>? machineId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Report/GetDefaultReport';
      final response = await get(url,
          query: {"BeginDate": beginDate.toString(), "EndDate": endDate.toString(), "MachineId": machineId},
          headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return ReportViewController.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  Future<ReportViewController?> getClosingReport(DateTime closingReportDateFilter, List<String>? machineId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Report/GetClosingReport';
      final response = await get(url,
          query: {"ClosingReportDateFilter": closingReportDateFilter.toString(), "MachineId": machineId},
          headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return ReportViewController.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }
}
