import 'package:elephant_control/base/models/user/model/user.dart';
import 'package:elephant_control/base/models/visit/model/visit.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/add_money_pouch_viewcontroller.dart';
import 'package:elephant_control/base/viewControllers/visit_list_viewcontroller.dart';

import '../viewControllers/money_pouch_viewcontroller.dart';

class VisitService extends BaseService {
  Future<bool> createVisit(Visit visit) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/CreateVisit';
      final data = visit.toJson();
      final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
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

  Future<bool> changeStatusMoneyWithdrawalToMoneyPouchReceived(AddMoneyPouchViewController addMoneyPouchViewController) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/ChangeStatusMoneyWithdrawalToMoneyPouchReceived';
      final response = await post(url, addMoneyPouchViewController.toJson(), headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> changeStatusMoneyWithdrawalToMoneyPouchLaunched(MoneyPouchViewController moneyPouchViewController) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Visit/ChangeStatusMoneyWithdrawalToMoneyPouchLaunched';
      final response = await post(url, moneyPouchViewController.toJson(), headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
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
}
