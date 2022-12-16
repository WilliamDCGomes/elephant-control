import 'package:elephant_control/app/views/pages/widgetsShared/popups/bottom_sheet_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../operatorPages/maintenanceHistory/popup/maintenance_information_popup.dart';
import '../operatorPages/maintenanceHistory/widgets/maintenance_body_card_widget.dart';
import '../operatorPages/maintenanceHistory/widgets/maintenance_header_card_widget.dart';

//ignore: must_be_immutable
class MaintenanceCardWidget extends StatefulWidget {
  final String machineName;
  final String workPriority;
  final int priorityColor;
  final String clock1;
  final String clock2;
  final String teddy;
  final bool pouchCollected;
  bool? showMap;
  RxString status;
  late RxBool operatorDeletedMachine;

  MaintenanceCardWidget(
      { Key? key,
        required this.machineName,
        required this.status,
        required this.workPriority,
        required this.priorityColor,
        required this.clock1,
        required this.clock2,
        required this.teddy,
        required this.pouchCollected,
        this.showMap,
      }) : super(key: key){
    operatorDeletedMachine = false.obs;
  }

  @override
  State<MaintenanceCardWidget> createState() => _MaintenanceCardWidgetState();
}

class _MaintenanceCardWidgetState extends State<MaintenanceCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextButtonWidget(
        onTap: (){
          BottomSheetPopup.showAlert(
            context,
            MaintenanceInformationPopup.getWidgetList(
              context,
              widget.machineName,
              widget.clock1,
              widget.clock2,
              widget.teddy,
              widget.status.value,
              widget.workPriority,
              widget.priorityColor,
              widget.pouchCollected,
            ),
          );
        },
        componentPadding: EdgeInsets.zero,
        widgetCustom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaintenanceHeaderCardWidget(
              machineName: widget.machineName,
              done: widget.status == "Finalizado",
              operatorDeletedMachine: widget.operatorDeletedMachine,
            ),
            MaintenanceBodyCardWidget(
              status: widget.status,
              workPriority: widget.workPriority,
              priorityColor: widget.priorityColor,
            ),
            Visibility(
              visible: widget.showMap ?? false,
              child: Container(
                color: AppColors.defaultColor,
                width: double.infinity,
                padding: EdgeInsets.all(1.h),
                child: TextWidget(
                  "Ver no mapa",
                  textColor: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  textDecoration: TextDecoration.none,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}