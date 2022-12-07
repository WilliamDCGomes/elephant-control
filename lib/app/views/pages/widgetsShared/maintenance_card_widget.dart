import 'package:elephant_control/app/views/pages/widgetsShared/popups/bottom_sheet_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../operatorPages/maintenanceHistory/popup/maintenance_information_popup.dart';
import '../operatorPages/maintenanceHistory/widgets/maintenance_body_card_widget.dart';
import '../operatorPages/maintenanceHistory/widgets/maintenance_header_card_widget.dart';

class MaintenanceCardWidget extends StatelessWidget {
  final String machineName;
  final String status;
  final String workPriority;
  final int priorityColor;
  final String clock1;
  final String clock2;
  final String teddy;
  final bool pouchCollected;

  const MaintenanceCardWidget(
      { Key? key,
        required this.machineName,
        required this.status,
        required this.workPriority,
        required this.priorityColor,
        required this.clock1,
        required this.clock2,
        required this.teddy,
        required this.pouchCollected
      }) : super(key: key);

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
              machineName,
              clock1,
              clock2,
              teddy,
              status,
              workPriority,
              priorityColor,
              pouchCollected,
            ),
          );
        },
        componentPadding: EdgeInsets.zero,
        widgetCustom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaintenanceHeaderCardWidget(
              machineName: machineName,
            ),
            MaintenanceBodyCardWidget(
              status: status,
              workPriority: workPriority,
              priorityColor: priorityColor,
            ),
          ],
        ),
      ),
    );
  }
}