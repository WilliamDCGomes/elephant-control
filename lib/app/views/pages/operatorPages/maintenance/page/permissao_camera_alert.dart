import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissaoCamera extends StatelessWidget {
  const PermissaoCamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Aviso"),
      content: const Text(
          "Você negou a permissão para a câmera permanentemente\nDeseja ir para a tela de configurações do aplicativo para habilitar essa permissão?"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'CANCELAR',
            style: TextStyle(
              color: Color(0xff12487d),
            ),
          ),
        ),
        TextButton(
          onPressed: () => openAppSettings(),
          child: Text(
            'ABRIR CONFIGURAÇÕES',
            style: TextStyle(
              color: AppColors.defaultColor,
            ),
          ),
        ),
      ],
    );
  }
}
