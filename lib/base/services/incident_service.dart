import 'package:elephant_control/base/models/incident/incident.dart';
import 'package:elephant_control/base/models/visitMedia/visit_media.dart';
import 'package:elephant_control/base/services/base/base_service.dart';
import 'package:elephant_control/base/services/base/iservice_post.dart';

import '../viewControllers/visit_media_h_viewcontroller.dart';

class IncidentService extends BaseService with MixinService {
  Future<bool> createIncident(Incident incident) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Incident/CreateIncident';
      final data = incident.toJson();
      final response = await post(url, data, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response) || response.body is! bool) throw Exception();
      return response.body;
    } catch (_) {
      return false;
    }
  }

  Future<bool> createIncidentMedia(List<VisitMediaHViewController> incidentsMedia) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'IncidentMedia/CreateIncidentMedia';
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
  Future<List<Incident>> getIncidentByVisitId(String visitId) async {
    try {
      final token = await getToken();
      final url = baseUrlApi + 'Incident/GetIncidentByVisitId';
      final response = await get(url, query: {"VisitId": visitId}, headers: {'Authorization': 'Bearer ${token}'});
      if (hasErrorResponse(response)) throw Exception();
      return (response.body as List).map((visitMedia) => Incident.fromJson(visitMedia)).toList();
    } catch (_) {
      return [];
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
  Future<List<Incident>> postOffline() async {
    try {
      List<Incident> userVisitMachines = [];
      final itens = await context.getNotSent(Incident.tableName);
      for (var item in itens) {
        final itemConvertido = Incident.fromJsonRepository(item);
        final token = await getToken();
        final url = baseUrlApi + 'Incident/CreateIncident';
        final response = await post(url, itemConvertido.toJson(), headers: {'Authorization': 'Bearer ${token}'});
        if (hasErrorResponse(response)) continue;
        userVisitMachines.add(itemConvertido);
        await context.removeTrully(Incident.tableName, itemConvertido.id!);
      }
      return userVisitMachines;
    } catch (_) {
      return [];
    }
  }
}
