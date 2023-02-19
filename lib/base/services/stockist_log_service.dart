import 'package:elephant_control/base/models/stockistLog/stockist_log.dart';
import 'package:elephant_control/base/services/base/base_service.dart';

import 'interfaces/istockist_log_service.dart';

class StockistLogService extends BaseService implements IStockistLogService {
  Future<List<StockistLog>> getStockistLog() async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'StockistLog/GetStockistLog';
      final response = await get(url, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<StockistLog>((e) => StockistLog.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<StockistLog>> getStockistLogByOperatorUserId(String userId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'StockistLog/GetStockistLogByOperatorUserId';
      final response = await get(url, query: {"UserId": userId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return response.body.map<StockistLog>((e) => StockistLog.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
