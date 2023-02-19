import '../../models/stockistLog/stockist_log.dart';

abstract class IStockistLogService {
  Future<List<StockistLog>> getStockistLog();
  Future<List<StockistLog>> getStockistLogByOperatorUserId(String userId);
}
