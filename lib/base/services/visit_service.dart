import 'package:elephant_control/base/models/user/user.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:elephant_control/base/repositories/user_visit_machine_repository.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/add_money_pouch_viewcontroller.dart';
import 'package:elephant_control/base/viewControllers/visit_list_viewcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewControllers/money_pouch_viewcontroller.dart';
import '../viewControllers/safe_box_financial_viewcontroller.dart';
import '../viewControllers/total_main_menu_operator_view_controller.dart';
import '../viewControllers/visit_viewcontroller.dart';
import '../viewControllers/visits_of_operators_viewcontroller.dart';
import 'base/iservice_post.dart';
import 'interfaces/ivisit_service.dart';

class VisitService extends BaseService with MixinService implements IVisitService {
  Future<bool> createVisit(Visit visit) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/CreateVisit';
      final data = visit.toJson();
      httpClient.timeout = Duration(minutes: 2);
      final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateVisit(Visit visit) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/UpdateVisit';
      final data = visit.toJson();
      httpClient.timeout = Duration(minutes: 2);
      final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteVisit(String visitId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/DeleteVisit';
      httpClient.timeout = Duration(minutes: 2);
      final response = await post(url, null, query: {"VisitId": visitId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<VisitViewController?> getResumeVisitById(String visitId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetResumeVisitById';
      final response = await get(url, query: {"VisitId": visitId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();

      return VisitViewController.fromJson(response.body.first);
    } catch (_) {
      return null;
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

  Future<List<VisitOfOperatorsViewController>> getVisitsOfOperatorsByUserId(List<String>? userId, DateTime? filterDate) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetVisitsOfOperatorsByUserId';
      final response = await get(url,
          query: {"UserId": userId, "filterDate": filterDate != null ? filterDate.toIso8601String() : ""},
          headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => VisitOfOperatorsViewController.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<VisitOfOperatorsViewController>> getVisitsOfOperatorsByUserIdAndPeriod(List<String>? userId, DateTime? initialFilterDate, DateTime? finalFilterDate) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/getVisitsOfOperatorsByUserIdAndPeriod';
      final response = await get(url,
          query: {
            "UserId": userId,
            "initialDateFilter": initialFilterDate != null ? initialFilterDate.toIso8601String() : "",
            "finalDateFilter": finalFilterDate != null ? finalFilterDate.toIso8601String() : "",
          },
          headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => VisitOfOperatorsViewController.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<TotalMainMenuOperatorViewcontroller>> getTotalMainMenuAdmin() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetTotalMainMenuAdmin';
      final response = await get(url,
          query: {"filterDate": DateTime.now().toIso8601String()}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => TotalMainMenuOperatorViewcontroller.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<SafeBoxFinancialViewController>> getVisitsOfFinancialByUserId(String? userId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetVisitsOfFinancialByUserId';
      final response = await get(url, query: {"UserId": userId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => SafeBoxFinancialViewController.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<SafeBoxFinancialViewController>> getVisitsByUserIdFinancial(String userId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetVisitsByUserIdFinancial';
      final response = await get(url, query: {"UserId": userId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => SafeBoxFinancialViewController.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<VisitListViewController>> getVisitsOperatorByUserId() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetVisitsOperatorByUserId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'}).timeout(Duration(minutes: 1));
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => VisitListViewController.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Visit?> getVisitByCode(int code) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetVisitByCode';
      final response = await get(url, query: {"Code": code}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return Visit.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  Future<List<Visit>> getAll() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetAll';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<Visit>((visit) => Visit.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> changeStatusMoneyWithdrawalToMoneyPouchReceived(
      AddMoneyPouchViewController addMoneyPouchViewController) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/ChangeStatusMoneyWithdrawalToMoneyPouchReceived';
      final response = await post(url, addMoneyPouchViewController.toJson(), headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> changeStatusMoneyPouchReceivedToMoneyPouchLaunched(MoneyPouchViewController moneyPouchViewController) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/ChangeStatusMoneyPouchReceivedToMoneyPouchLaunched';
      final response = await post(url, moneyPouchViewController.toJson(), headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> changeStatusMoneyPouchLaunchedToFinished(String visitId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/ChangeStatusMoneyPouchLaunchedToFinished';
      final response = await post(url, null, query: {"VisitId": visitId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<List<Visit>> getVisitWithStatusMoneyPouchLaunchedOrRealized() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetVisitWithStatusMoneyPouchLaunchedOrRealized';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<Visit>((visit) => Visit.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<MoneyPouchViewController>> getMoneyPouchVisitByOperatorUserId() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetMoneyPouchVisitByOperatorUserId';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => MoneyPouchViewController.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<User>> getOperatorUsersWithVisitStatusMoneyWithdrawal() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/GetOperatorUsersWithVisitStatusMoneyWithdrawal';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visit) => User.fromJson(visit)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> recallMoneyVisitsByUserId(String treasuryUserId, double? recallMoney) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/RecallMoneyVisitsByUserId';
      final response = await post(url, null,
          query: {"TreasuryUserId": treasuryUserId, "RecallMoney": recallMoney?.toString()},
          headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List> getOffline() {
    throw UnimplementedError();
  }

  @override
  Future<List<Visit>> postOffline() async {
    try {
      List<Visit> userVisitMachines = [];
      final itens = await context.getNotSent(Visit.tableName);
      for (var item in itens) {
        final itemConvertido = Visit.fromJsonRepository(item);
        final token = await getToken();
        final url = baseUrlApi + 'Visit/CreateVisit';
        sharedPreferences ??= await SharedPreferences.getInstance();
        final response = await post(url, itemConvertido.toJson(),
            query: {"LastSincronism": sharedPreferences?.getString("LastSincronism")},
            headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response)) continue;
        userVisitMachines.add(itemConvertido);
        if (await UserVisitMachineRepository().deleteUserVisitMachineByVisitId(itemConvertido.id!)) {
          await context.removeTrully(Visit.tableName, itemConvertido.id!);
        }
      }
      return userVisitMachines;
    } catch (_) {
      return [];
    }
  }
}
