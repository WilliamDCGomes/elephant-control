import '../../viewControllers/safe_box_financial_viewcontroller.dart';
import '../../viewControllers/total_main_menu_operator_view_controller.dart';
import '../../viewControllers/visits_of_operators_viewcontroller.dart';

abstract class IVisitService {
  Future<List<VisitOfOperatorsViewController>> getVisitsOfOperatorsByUserId(List<String>? userId, DateTime? filterDate);

  Future<List<VisitOfOperatorsViewController>> getVisitsOfOperatorsByUserIdAndPeriod(List<String>? userId, DateTime? initialFilterDate, DateTime? finalFilterDate);

  Future<List<SafeBoxFinancialViewController>> getVisitsOfFinancialByUserId(String? userId);

  Future<List<SafeBoxFinancialViewController>> getVisitsByUserIdFinancial(String userId);

  Future<List<TotalMainMenuOperatorViewcontroller>> getTotalMainMenuAdmin();
}
