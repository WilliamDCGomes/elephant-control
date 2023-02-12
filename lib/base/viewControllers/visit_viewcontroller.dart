import 'package:elephant_control/base/viewControllers/visit_media_viewcontroller.dart';

class VisitViewController {
  late bool collectedDrawal;
  late bool visitMonthClosure;
  late int replacedPlush;
  late int? secondClock;
  late String machineName;
  late String machineId;
  late String? observation;
  late double firstClock;
  late DateTime inclusion;
  late List<VisitMediaViewController> mediasList;

  VisitViewController({
    required this.collectedDrawal,
    required this.visitMonthClosure,
    required this.replacedPlush,
    required this.secondClock,
    required this.machineName,
    required this.machineId,
    required this.observation,
    required this.firstClock,
    required this.inclusion,
    required this.mediasList,
  });

  VisitViewController.emptyConstructor();

  //NÃO USAR O PACKAGE DO JSON AQUI, CONVERSÃO MANUAL
  VisitViewController.fromJson(Map<String, dynamic> json) {
    collectedDrawal = json["collectedDrawal"];
    visitMonthClosure = json["visitMonthClosure"];
    replacedPlush = json["replacedPlush"];
    secondClock = json["secondClock"];
    machineName = json["machineName"];
    machineId = json["machineId"];
    observation = json["observation"];
    firstClock = json["firstClock"];
    mediasList = (json["mediasList"] as List).isNotEmpty
        ? (json["mediasList"] as List)
            .map(
              (media) => VisitMediaViewController.fromJson(media),
            )
            .toList()
        : [];
    inclusion = DateTime.parse(json['inclusion'] as String);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["collectedDrawal"] = this.collectedDrawal;
    data["visitMonthClosure"] = this.visitMonthClosure;
    data["replacedPlush"] = this.replacedPlush;
    data["secondClock"] = this.secondClock;
    data["machineName"] = this.machineName;
    data["machineId"] = this.machineId;
    data["observation"] = this.observation;
    data["firstClock"] = this.firstClock;
    data["inclusion"] = this.inclusion;
    data["mediasList"] = this.mediasList;
    return data;
  }
}
