import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:get/state_manager.dart';
import '../../../../../../base/models/stokistPlush/stokist_plush.dart';
import '../../../../../../base/services/stokist_plush_service.dart';

class StockControlController extends GetxController {
  late RxBool screenLoading;
  late RxInt plushQuantity;
  late Rx<DateTime> quantityLastUpdate;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late StokistPlush? stokistPlush;
  late StokistPlushService _stokistPlushService;

  StockControlController() {
    _initializeVariables();
  }
  @override
  onInit() async {
    await getQuantityData();
    super.onInit();
  }

  _initializeVariables(){
    screenLoading = true.obs;
    plushQuantity = 0.obs;
    quantityLastUpdate = DateTime.now().obs;
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    stokistPlush = null;
    _stokistPlushService = StokistPlushService();
  }

  Future<void> getQuantityData() async {
    try {
      screenLoading.value = true;
      stokistPlush = await _stokistPlushService.getPlushies();
      if(stokistPlush != null){
        plushQuantity.value = stokistPlush!.balanceStuffedAnimals;
        if(stokistPlush!.alteration != null) {
          quantityLastUpdate.value = stokistPlush!.alteration!;
        }
      }
    } catch (_) {
    } finally {
      screenLoading.value = false;
    }
  }
}