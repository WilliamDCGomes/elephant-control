import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../controller/maintenance_history_controller.dart';

class FilterMaintenanceListPopup extends StatefulWidget {
  final MaintenanceHistoryController controller;

  const FilterMaintenanceListPopup({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<FilterMaintenanceListPopup> createState() => _FilterMaintenanceListPopupState();
}

class _FilterMaintenanceListPopupState extends State<FilterMaintenanceListPopup> {
  late bool showPopup;

  @override
  void initState() {
    showPopup = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 150));
      setState(() {
        showPopup = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Visibility(
        visible: showPopup,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.h),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(2.h),
                  color: AppColors.defaultColor,
                  child: TextWidget(
                    "Selecione uma cidade para filtrar a lista",
                    textColor: AppColors.whiteColor,
                    fontSize: 18.sp,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.controller.cityItemCardWidgetList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(2.h),
                    itemBuilder: (context, index){
                      return InkWell(
                        onTap: () => widget.controller.filterMaintenanceList(index),
                        child: widget.controller.cityItemCardWidgetList[index],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 2.h),
                  child: ButtonWidget(
                    hintText: "Remover Filtros",
                    fontWeight: FontWeight.bold,
                    widthButton: double.infinity,
                    onPressed: () => widget.controller.removeFilter(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}