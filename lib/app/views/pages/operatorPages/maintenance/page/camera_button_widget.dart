import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CameraButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String textoBotao;
  final bool solicitacao;
  const CameraButtonWidget({Key? key, this.onPressed, required this.textoBotao, this.solicitacao = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(solicitacao ? AppColors.defaultColor : AppColors.transparentColor),
        ),
        child: Text(
          textoBotao,
          style: TextStyle(fontSize: 19.sp),
          textAlign: TextAlign.center,
        ));
  }
}
