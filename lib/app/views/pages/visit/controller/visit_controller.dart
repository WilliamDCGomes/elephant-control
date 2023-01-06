import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import '../../../../../base/models/visit/model/visit.dart';
import '../../../../../base/services/visit_service.dart';

class VisitController extends GetxController {
  late TextEditingController searchVisits;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final VisitService _visitService;
  late final RxList<Visit> _visits;

  VisitController() {
    searchVisits = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _visitService = VisitService();
    _visits = <Visit>[].obs;
  }
  @override
  onInit() async {
    await Future.delayed(Duration(milliseconds: 200));
    await getVisits();
    super.onInit();
  }

  //Getters
  List<Visit> get visits => searchVisits.text.toLowerCase().trim().isEmpty ? _visits.where((p0) => p0.active == true).toList() : _visits.where((p0) => p0.machine!.name.toLowerCase().trim().contains(searchVisits.text.toLowerCase().trim()) && p0.active == true).toList();

  Future<void> getVisits() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      _visits.clear();
      _visits.addAll(await _visitService.getAll());
    } catch (e) {
      print(e);
    } finally {
      _visits.refresh();
      _visits.sort((a, b) => a.machine!.name.trim().toLowerCase().compareTo(b.machine!.name.trim().toLowerCase()));
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  void updateList() {
    _visits.refresh();
  }

  Future<void> addVisitVisit() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
    } catch (_) {
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> deleteVisit(Visit visit) async {
    // try {
    //   await loadingWithSuccessOrErrorWidget.startAnimation();
    //   visit.active = false;
    //   final deleted = await _visitService.editVisit(visit);
    //   if (!deleted) throw Exception();
    //   await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Atendimento deletado com sucesso"));
    // } catch (_) {
    //   await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível deletar o atendimento"));
    // } finally {
    //   await getVisits();
    //   await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    // }
  }

  // Future<void> editVisit(Visit? visit) async {
  //   final _visit = await Get.to(() => RegisterVisitsPage(
  //         visit: visit,
  //         edit: visit != null,
  //       ));
  //   if (_visit is! Visit) return;
  //   try {
  //     await loadingWithSuccessOrErrorWidget.startAnimation();
  //     final editted = visit != null ? await _visitService.editVisit(_visit) : await _visitService.createVisit(_visit);
  //     if (!editted) throw Exception();
  //     await getVisits();
  //     await loadingWithSuccessOrErrorWidget.stopAnimation();
  //     await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Atendimento ${visit != null ? "editado" : "criado"} com sucesso"));
  //   } catch (_) {
  //     await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
  //     await showDialog(context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Não foi possível  ${visit != null ? "editar" : "criar"} o atendimento"));
  //   }
  // }
}
