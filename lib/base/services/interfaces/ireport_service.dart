import '../../viewControllers/report_viewcontroller.dart';

abstract class IReportService {
  Future<ReportViewController> getDefaultReport(DateTime beginDate, DateTime endDate, String? machineId);
}