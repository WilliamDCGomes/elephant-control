import '../../viewControllers/safe_box_financial_viewcontroller.dart';
import '../../viewControllers/visits_of_operators_viewcontroller.dart';

abstract class IVisitService {
  Future<List<VisitOfOperatorsViewController>> getVisitsOfOperatorsByUserId(String? userId, DateTime? filterDate);

  Future<List<SafeBoxFinancialViewController>> getVisitsOfFinancialByUserId(String? userId);

  Future<List<SafeBoxFinancialViewController>> getVisitsByUserIdFinancial(String userId);
}