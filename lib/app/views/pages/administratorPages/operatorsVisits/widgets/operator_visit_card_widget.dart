import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/popups/bottom_sheet_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:elephant_control/base/models/visit/visit.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/viewControllers/visits_of_operators_viewcontroller.dart';
import '../../../operatorPages/maintenanceHistory/popups/maintenance_information_popup.dart';
import '../../../operatorPages/maintenanceHistory/widgets/maintenance_body_card_widget.dart';
import '../../../operatorPages/maintenanceHistory/widgets/maintenance_header_card_widget.dart';
import '../../operetorsVisitPeriodFilter/controller/operetors_visit_period_filter_controller.dart';
import '../controller/operators_visits_controller.dart';

class OperatorVisitCardWidget extends StatefulWidget {
  final bool showBody;
  final OperatorsVisitsController? operatorsVisitsController;
  final OperatorsVisitsPeriodFilterController? operatorsVisitsPeriodFilterController;
  final VisitOfOperatorsViewController visitOfOperatorsViewController;

  const OperatorVisitCardWidget({
    Key? key,
    required this.visitOfOperatorsViewController,
    this.operatorsVisitsController,
    this.showBody = true,
    this.operatorsVisitsPeriodFilterController,
  }) : super(key: key);

  @override
  State<OperatorVisitCardWidget> createState() => _OperatorVisitCardWidgetState();
}

class _OperatorVisitCardWidgetState extends State<OperatorVisitCardWidget> {
  String _getVisitPriority() {
    if (widget.visitOfOperatorsViewController.lastMachineVisit != null) {
      int nextTime = widget.visitOfOperatorsViewController.periodDaysToVisit ?? 0;
      DateTime nextVisit = widget.visitOfOperatorsViewController.lastMachineVisit!.add(Duration(days: nextTime));
      if (nextTime != 0 && DateTime.now().compareTo(nextVisit) != -1) {
        return "ALTA";
      }
    }
    return "NORMAL";
  }

  int _getColorPriority() {
    if (widget.visitOfOperatorsViewController.lastMachineVisit != null) {
      int nextTime = widget.visitOfOperatorsViewController.periodDaysToVisit ?? 0;
      DateTime nextVisit = widget.visitOfOperatorsViewController.lastMachineVisit!.add(Duration(days: nextTime));
      if (nextTime != 0 && DateTime.now().compareTo(nextVisit) != -1) {
        return AppColors.redColor.value;
      }
    }
    return AppColors.greenColor.value;
  }

  String getStatus() {
    return widget.visitOfOperatorsViewController.visitedMachine.isNotEmpty &&
            !widget.visitOfOperatorsViewController.visitedMachine.contains("00000000-0000-0000-0000-000000000000")
        ? "Finalizado"
        : "Pendente";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextButtonWidget(
        onTap: () {
          BottomSheetPopup.showAlert(
            context,
            MaintenanceInformationPopup.getWidgetList(
              context,
              widget.visitOfOperatorsViewController.machineName,
              widget.visitOfOperatorsViewController.firstClock.toStringAsFixed(0),
              (widget.visitOfOperatorsViewController.secondClock ?? 0).toString(),
              widget.visitOfOperatorsViewController.addedProducts.toString(),
              getStatus(),
              _getVisitPriority(),
              _getColorPriority(),
              widget.visitOfOperatorsViewController.visitStatus == VisitStatus.moneyWithdrawal,
              widget.visitOfOperatorsViewController.operatorName,
              widget.visitOfOperatorsViewController.visitId,
              widget.visitOfOperatorsViewController.vInclusion,
              null,
              editPictures: false,
              operatorsVisitsController: widget.operatorsVisitsController,
              operatorsVisitsPeriodFilterController: widget.operatorsVisitsPeriodFilterController,
            ),
          );
        },
        componentPadding: EdgeInsets.zero,
        widgetCustom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaintenanceHeaderCardWidget(
              machineName: widget.visitOfOperatorsViewController.machineName + (widget.showBody ? "" : " - ${DateFormatToBrazil.formatDateAndHour(widget.visitOfOperatorsViewController.vInclusion)}"),
              done: getStatus() == "Finalizado",
              operatorDeletedMachine: false,
              hasIncident: widget.visitOfOperatorsViewController.hasIncident,
              maxLines: 2,
            ),
            Visibility(
              visible: widget.showBody,
              child: MaintenanceBodyCardWidget(
                status: getStatus(),
                workPriority: _getVisitPriority(),
                priorityColor: _getColorPriority(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
