import 'package:elephant_control/base/models/incidentMedia/incident_media.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/services/base/iservice_post.dart';
import '../viewControllers/visit_media_h_viewcontroller.dart';

class IncidentMediaService extends BaseService with MixinService {
  Future<bool> createIncidentMedia(List<VisitMediaHViewController> incidentsMedia) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Incident/CreateIncidentMedia';
      for (var element in incidentsMedia) {
        final data = element.toJson();
        final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  ///Retorna visitMedia, mas tem um incidentId nullable dentro
  Future<List<VisitMediaHViewController>> getIncidentMediaByIncidentId(String incidentId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Incident/GetIncidentMediaByIncidentId';
      final response = await get(url, query: {"IncidentId": incidentId}, headers: {'Authorization': 'Bearer ${token}'});
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
  Future<List<IncidentMedia>> postOffline() async {
    try {
      List<IncidentMedia> userVisitMachines = [];
      final itens = await context.getNotSent(IncidentMedia.tableName);
      for (var item in itens) {
        final itemConvertido = IncidentMedia.fromJsonRepository(item);
        final token = await getToken();
        final url = baseUrlApi + 'Incident/CreateIncidentMedia';
        final data = VisitMediaHViewController(
            type: itemConvertido.type,
            visitId: itemConvertido.incidentId,
            media: itemConvertido.media,
            extension: itemConvertido.extension);
        final response = await post(url, data.toJson(), headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response)) continue;
        userVisitMachines.add(itemConvertido);
        itemConvertido.sent = true;
        await context.removeTrully(IncidentMedia.tableName, itemConvertido.id!);
      }
      return userVisitMachines;
    } catch (_) {
      return [];
    }
  }
}
