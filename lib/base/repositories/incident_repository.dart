import 'package:elephant_control/base/models/incident/incident.dart';
import 'package:elephant_control/base/models/incidentMedia/incident_media.dart';
import 'package:elephant_control/base/repositories/base/base_repository.dart';
import '../viewControllers/visit_media_h_viewcontroller.dart';

class IncidentRepository extends BaseRepository {
  Future<bool> createIncident(Incident incident) async {
    try {
      incident.sent = false;
      await context.insert(Incident.tableName, incident.toJsonRepository());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> createIncidentMedia(List<VisitMediaHViewController> incidentsMedia) async {
    try {
      for (var incidentMedia in incidentsMedia) {
        final _incidentMedia = IncidentMedia(
          id: incidentMedia.mediaId,
          inclusion: DateTime.now(),
          alteration: DateTime.now(),
          incidentId: incidentMedia.incidentId!,
          type: incidentMedia.type,
          extension: incidentMedia.extension!,
          media: incidentMedia.base64!,
          sent: false,
        );
        await context.insert(IncidentMedia.tableName, _incidentMedia.toJsonRepository());
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
