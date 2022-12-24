import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/viewControllers/money_pouch_value_viewcontroller.dart';
import '../models/visit.dart';

class MoneyPouchService extends BaseService {
  /// Se não enviar userId vai pegar do usuário que está logado
  Future<MoneyPouchValueViewController?> getMoneyPouchValue(String? userId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'MoneyPouch/GetMoneyPouchValue';
      final response = await get(url, query: {"UserId": userId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return MoneyPouchValueViewController.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }

  ///Dentro da visita terá o malote
  Future<List<Visit>> getMoneyPouchLaunched() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'MoneyPouch/GetMoneyPouchLaunched';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((e) => Visit.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  ///Dentro da visita terá o malote
  Future<List<Visit>> getMoneyPouchReceived() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'MoneyPouch/GetMoneyPouchReceived';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((e) => Visit.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  ///Dentro da visita terá o malote
  Future<List<Visit>> getMoneyPouchMoneyWithdrawal() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'MoneyPouch/GetMoneyPouchMoneyWithdrawal';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((e) => Visit.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
