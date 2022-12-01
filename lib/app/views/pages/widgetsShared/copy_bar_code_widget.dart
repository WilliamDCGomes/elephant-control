import 'package:elephant_control/app/views/pages/widgetsShared/snackbar_widget.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../stylePages/app_colors.dart';

class CopyBarCodeWidget extends StatelessWidget {
  final String successText;
  final String valueCopy;
  final Widget widgetCustom;

  const CopyBarCodeWidget(
      { Key? key,
        required this.successText,
        required this.valueCopy,
        required this.widgetCustom,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButtonWidget(
      onTap: (){
        Clipboard.setData(ClipboardData(text: valueCopy));
        SnackbarWidget(
          warningText: "Sucesso",
          informationText: successText,
          backgrondColor: AppColors.purpleColorWithOpacity
        );
      },
      componentPadding: EdgeInsets.zero,
      widgetCustom: widgetCustom,
    );
  }
}