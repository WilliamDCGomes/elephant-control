import '../../viewControllers/visits_of_operators_viewcontroller.dart';

abstract class IVisitService {
  Future<List<VisitOfOperatorsViewController>> getVisitsOfOperatorsByUserId(String userId, DateTime? filterDate);
}