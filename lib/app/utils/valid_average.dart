import 'package:elephant_control/base/services/machine_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../base/models/machine/machine.dart';
import '../views/pages/widgetsShared/popups/information_popup.dart';
import '../views/pages/widgetsShared/text_widget.dart';
import '../views/stylePages/app_colors.dart';

class ValidAverage{
  valid(String machineId, String clock1, String clock2) async {
    try {
      MachineService _machineService = MachineService();
      Machine? _machine = await _machineService.getMachineById(machineId);

      if(_machine != null && (_machine.minimumAverageValue == 0 || _machine.maximumAverageValue == 0)){
        if(await _machineService.setAverageMachine(machineId)){
          _machine = await _machineService.getMachineById(machineId);
        }
      }

      if(_machine != null){
        double averageValue = int.parse(clock1) / int.parse(clock2);

        if (averageValue < _machine.minimumAverageValue || averageValue > _machine.maximumAverageValue) {
          await showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return InformationPopup(
                warningMessage: "A média dessa máquina está fora do programado!\nMédia: ${averageValue
                    .toStringAsFixed(2).replaceAll('.', ',')}",
                fontSize: 18.sp,
                popupColor: AppColors.redColor,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      color: AppColors.yellowDarkColor,
                      size: 4.h,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    TextWidget(
                      "AVISO",
                      textColor: AppColors.whiteColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Icon(
                      Icons.warning,
                      color: AppColors.yellowDarkColor,
                      size: 4.h,
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    } catch (_) {

    }
  }
}