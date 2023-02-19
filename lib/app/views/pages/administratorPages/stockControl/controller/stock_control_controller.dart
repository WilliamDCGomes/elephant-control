import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/base/services/stockist_log_service.dart';
import 'package:get/state_manager.dart';
import '../../../../../../base/models/stockistLog/stockist_log.dart';
import '../../../../../../base/models/stokistPlush/stokist_plush.dart';
import '../../../../../../base/services/interfaces/istockist_log_service.dart';
import '../../../../../../base/services/stokist_plush_service.dart';

class StockControlController extends GetxController {
  late RxBool screenLoading;
  late RxInt plushQuantity;
  late Rx<DateTime> quantityLastUpdate;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late StokistPlush? stokistPlush;
  late StokistPlushService _stokistPlushService;
  late final IStockistLogService _stockistLogService;
  late RxList<StockistLog> stockistLog;
  late RxBool showInfos;

  StockControlController() {
    _initializeVariables();
  }
  @override
  onInit() async {
    await getQuantityData();
    super.onInit();
  }

  _initializeVariables() {
    screenLoading = true.obs;
    plushQuantity = 0.obs;
    quantityLastUpdate = DateTime.now().obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    stokistPlush = null;
    _stokistPlushService = StokistPlushService();
    _stockistLogService = StockistLogService();
    stockistLog = stockistLog = <StockistLog>[].obs;
    showInfos = true.obs;
  }

  Future<void> getStockistLog() async {
    try {
      stockistLog.clear();
      stockistLog.addAll(await _stockistLogService.getStockistLog());
    } catch (_) {
      stockistLog.clear();
    }
  }

  Future<void> getQuantityData() async {
    try {
      screenLoading.value = true;
      stokistPlush = await _stokistPlushService.getPlushies();
      if (stokistPlush != null) {
        plushQuantity.value = stokistPlush!.balanceStuffedAnimals;
        if (stokistPlush!.alteration != null) {
          quantityLastUpdate.value = stokistPlush!.alteration!;
        }
      }
      await getStockistLog();
    } catch (_) {
    } finally {
      screenLoading.value = false;
    }
  }
}
