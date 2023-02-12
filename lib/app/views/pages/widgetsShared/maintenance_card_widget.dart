import 'package:elephant_control/app/views/pages/widgetsShared/popups/bottom_sheet_popup.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/rich_text_two_different_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../operatorPages/maintenanceHistory/popups/maintenance_information_popup.dart';
import '../operatorPages/maintenanceHistory/widgets/maintenance_body_card_widget.dart';
import '../operatorPages/maintenanceHistory/widgets/maintenance_header_card_widget.dart';

class MaintenanceCardWidget extends StatefulWidget {
  final String visitId;
  final String machineName;
  final String city;
  final String workPriority;
  final double? latitude;
  final double? longitude;
  final int priorityColor;
  final bool showRadius;
  final String clock1;
  final String clock2;
  final String teddy;
  final bool pouchList;
  final bool pouchCollected;
  final bool showPriorityAndStatus;
  final bool? showMap;
  final bool setHeight;
  final bool machineAddOtherList;
  final String? responsibleName;
  final bool operatorDeletedMachine;
  final String status;
  final bool decoratorLine;
  final bool onTapDesabilitate;
  final DateTime visitDate;
  final dynamic Function()? onTap;
  final Widget? child;
  final List<Widget> childMaintenanceHeaderCardWidget;
  final Color? machineContainerColor;
  final int? maxLines;

  const MaintenanceCardWidget({
    super.key,
    required this.visitId,
    required this.machineName,
    required this.city,
    required this.status,
    required this.workPriority,
    required this.priorityColor,
    required this.clock1,
    required this.clock2,
    required this.teddy,
    required this.pouchCollected,
    required this.visitDate,
    this.pouchList = true,
    this.showRadius = true,
    this.setHeight = true,
    this.showPriorityAndStatus = true,
    this.showMap,
    this.responsibleName,
    this.latitude,
    this.longitude,
    this.machineAddOtherList = false,
    this.operatorDeletedMachine = false,
    this.decoratorLine = false,
    this.onTapDesabilitate = true,
    this.child,
    this.machineContainerColor,
    this.childMaintenanceHeaderCardWidget = const [],
    this.onTap,
    this.maxLines,
  });

  @override
  State<MaintenanceCardWidget> createState() => _MaintenanceCardWidgetState();
}

class _MaintenanceCardWidgetState extends State<MaintenanceCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextButtonWidget(
        onTap: widget.onTap ??
            (!widget.onTapDesabilitate
                ? null
                : () {
                    BottomSheetPopup.showAlert(
                      context,
                      MaintenanceInformationPopup.getWidgetList(
                        context,
                        widget.machineName,
                        widget.clock1,
                        widget.clock2,
                        widget.teddy,
                        widget.status,
                        widget.workPriority,
                        widget.priorityColor,
                        widget.pouchCollected,
                        widget.responsibleName,
                        widget.visitId,
                        widget.visitDate,
                        null,
                      ),
                    );
                  }),
        componentPadding: EdgeInsets.zero,
        widgetCustom: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.setHeight ? 10.h : null,
              child: MaintenanceHeaderCardWidget(
                machineName: widget.machineName,
                maxLines: widget.maxLines,
                done: widget.machineAddOtherList, //widget.status == "Realizada" || widget.status == "Malote retirado",
                operatorDeletedMachine: widget.operatorDeletedMachine,
                decoratorLine: widget.decoratorLine,
                latitude: widget.latitude,
                longitude: widget.longitude,
                decoration: BoxDecoration(
                  color: widget.machineContainerColor ?? Color(widget.priorityColor),
                  borderRadius: widget.showRadius ? BorderRadius.circular(2.h) : null,
                ),
                children: widget.childMaintenanceHeaderCardWidget,
              ),
            ),
            widget.child ??
                (widget.showPriorityAndStatus
                    ? widget.decoratorLine
                        ? const SizedBox()
                        : MaintenanceBodyCardWidget(
                            status: widget.status,
                            workPriority: widget.workPriority,
                            priorityColor: widget.priorityColor,
                          )
                    : Container(
                        height: 5.h,
                        width: double.infinity,
                        color: AppColors.grayBackgroundPictureColor,
                        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                        child: Center(
                          child: RichTextTwoDifferentWidget(
                            firstText: widget.pouchList ? "Malote retirado da máquina? " : "Pelúcias adicionadas à maquina: ",
                            firstTextColor: AppColors.blackColor,
                            firstTextFontWeight: FontWeight.bold,
                            firstTextSize: 14.5.sp,
                            secondText: widget.pouchList
                                ? widget.pouchCollected
                                    ? "Sim"
                                    : "Não"
                                : widget.teddy,
                            secondTextColor: AppColors.greenColor,
                            secondTextFontWeight: FontWeight.bold,
                            secondTextSize: 14.5.sp,
                            secondTextDecoration: TextDecoration.none,
                          ),
                        ),
                      )),
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
