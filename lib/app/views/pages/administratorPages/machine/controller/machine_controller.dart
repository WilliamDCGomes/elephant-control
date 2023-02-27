import 'package:elephant_control/app/views/pages/widgetsShared/loading_with_success_or_error_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/information_popup.dart';
import 'package:elephant_control/base/services/machine_service.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../base/models/machine/machine.dart';
import '../../../../../../base/services/interfaces/ivisit_service.dart';
import '../../../../../../base/services/visit_service.dart';
import '../../../../../utils/date_format_to_brazil.dart';
import '../../../../../utils/generate_report_pdf.dart';
import '../../registerMachine/page/register_machine_page.dart';

class MachineController extends GetxController {
  late RxBool screenLoading;
  late TextEditingController searchMachines;
  late LoadingWithSuccessOrErrorWidget loadingWithSuccessOrErrorWidget;
  late final MachineService _machineService;
  late final IVisitService _visitService;
  late final RxList<Machine> _machines;

  MachineController() {
    _initializeVariables();
  }

  @override
  onInit() async {
    await _getMachines();
    super.onInit();
  }

  _initializeVariables() {
    screenLoading = true.obs;
    searchMachines = TextEditingController();
    loadingWithSuccessOrErrorWidget = LoadingWithSuccessOrErrorWidget();
    _machineService = MachineService();
    _visitService = VisitService();
    _machines = <Machine>[].obs;
  }

  //Getters
  List<Machine> get machines => searchMachines.text.toLowerCase().trim().isEmpty
      ? _machines.where((p0) => p0.active == true).toList()
      : _machines
          .where(
              (p0) => p0.name.toLowerCase().trim().contains(searchMachines.text.toLowerCase().trim()) && p0.active == true)
          .toList();

  Future<void> _getMachines() async {
    try {
      _machines.clear();
      _machines.addAll(await _machineService.getAll());
      _machines.refresh();
      _machines.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      screenLoading.value = false;
    } catch (e) {
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro buscar as máquinas! Tente novamente mais tarde.",
          );
        },
      );
      Get.back();
    }
  }

  generateReportPdf() async {
    try{
      List<String>? machineIds = <String>[];

      for(var machine in machines){
        if(machine.id != null){
          machineIds.add(machine.id!);
        }
      }

      var machinesVisits = await _visitService.getLastMachinesVisits(machineIds);

      var reportFile = await GenerateReportPdf.generateMachinePdf(machinesVisits);

      if(reportFile != null){
        await Share.shareXFiles(
          [XFile(reportFile.path)],
          text: "Relatório " + DateFormatToBrazil.formatDateAndHour(DateTime.now()),
        );
      }
      else{
        throw Exception();
      }
    }
    catch(_){
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao exportar o relatório! Tente diminuir a quantidade de máquinas selecionadas para exportar o relatório.",
          );
        },
      );
    }
  }

  void updateList() {
    _machines.refresh();
  }

  Future<void> addUserMachine() async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
    } catch (_) {
    } finally {
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> deleteMachine(Machine machine) async {
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      machine.active = false;
      final deleted = await _machineService.createOrUpdateMachine(machine);
      if (!deleted) throw Exception();
      await showDialog(
          context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Máquina deletada com sucesso"));
    } catch (_) {
      await showDialog(
          context: Get.context!,
          builder: (context) => InformationPopup(warningMessage: "Não foi possível deletar a máquina"));
    } finally {
      await _getMachines();
      await loadingWithSuccessOrErrorWidget.stopAnimation(justLoading: true);
    }
  }

  Future<void> editMachine(Machine? machine) async {
    final _machine = await Get.to(() => RegisterMachinePage(
          machine: machine,
          edit: machine != null,
          externalIds: [], //machines.where((element) => element.externalId != null).map((e) => e.externalId!).toList(),
        ));
    if (_machine is! Machine) return;
    try {
      await loadingWithSuccessOrErrorWidget.startAnimation();
      final editted = await _machineService.createOrUpdateMachine(_machine);
      if (!editted) throw Exception();
      await _getMachines();
      await loadingWithSuccessOrErrorWidget.stopAnimation();
      await showDialog(
          context: Get.context!, builder: (context) => InformationPopup(warningMessage: "Máquina editada com sucesso"));
    } catch (_) {
      await loadingWithSuccessOrErrorWidget.stopAnimation(fail: true);
      await showDialog(
          context: Get.context!,
          builder: (context) => InformationPopup(warningMessage: "Não foi possível editar a máquina"));
    }
  }
}
