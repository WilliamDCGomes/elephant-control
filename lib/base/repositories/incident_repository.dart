import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:elephant_control/base/models/incident/incident.dart';
import 'package:elephant_control/base/models/incidentMedia/incident_media.dart';
import 'package:elephant_control/base/repositories/base/base_repository.dart';
import '../viewControllers/visit_media_h_viewcontroller.dart';

class IncidentRepository extends BaseRepository {
  Future<bool> createIncident(Incident incident) async {
    try {
      incident.sent = false;
      incident.responsibleUserId = LoggedUser.id;
      incident.operatorUserId = LoggedUser.id;
      incident.status = IncidentStatus.realized;
      await context.insert(Incident.tableName, incident.toJsonRepository());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> createIncidentMedia(List<VisitMediaHViewController> incidentsMedia, String incidentId) async {
    try {
      for (var incidentMedia in incidentsMedia) {
        final _incidentMedia = IncidentMedia(
          id: incidentMedia.mediaId,
          inclusion: DateTime.now(),
          alteration: DateTime.now(),
          incidentId: incidentId,
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
