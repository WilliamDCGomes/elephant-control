import 'package:elephant_control/base/models/visitMedia/visit_media.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import '../viewControllers/visit_media_h_viewcontroller.dart';
import 'base/iservice_post.dart';

class VisitMediaService extends BaseService with MixinService {
  Future<bool> createVisitMedia(List<VisitMediaHViewController> visitsMedia) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'VisitMedia/CreateVisitMedia';
      httpClient.timeout = Duration(minutes: 2);
      for (var element in visitsMedia) {
        final data = element.toJson();
        final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateVisitMedia(List<VisitMedia> visitsMedia) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'VisitMedia/UpdateVisitMedia';
      httpClient.timeout = Duration(minutes: 2);
      for (var element in visitsMedia) {
        final data = element.toJson();
        final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<VisitMediaHViewController>> getVisitMediaByVisitId(String visitId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'VisitMedia/GetVisitMediaByVisitId';
      httpClient.timeout = Duration(minutes: 2);
      final response = await get(url, query: {"VisitId": visitId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visitMedia) => VisitMediaHViewController.fromJson(visitMedia)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List> getOffline() {
    throw UnimplementedError();
  }

  @override
  Future<List<VisitMedia>> postOffline() async {
    try {
      List<VisitMedia> userVisitMachines = [];
      final itens = await context.getNotSent(VisitMedia.tableName);
      for (var item in itens) {
        final itemConvertido = VisitMedia.fromJsonRepository(item);
        final token = await getToken();
        final url = baseUrlApi + 'VisitMedia/CreateVisitMedia';
        final data = VisitMediaHViewController(
            type: itemConvertido.type,
            visitId: itemConvertido.visitId,
            media: itemConvertido.media,
            extension: itemConvertido.extension);
        final response = await post(url, data.toJson(), headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response)) continue;
        userVisitMachines.add(itemConvertido);
        await context.removeTrully(VisitMedia.tableName, itemConvertido.id!);
      }
      return userVisitMachines;
    } catch (_) {
      return [];
    }
  }
}
