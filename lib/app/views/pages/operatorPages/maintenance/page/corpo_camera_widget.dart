import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'botao_camera_widget.dart';

class CorpoCameraWidget extends StatelessWidget {
  final Widget childCamera;
  final bool flashLigado;
  final CameraController? controller;
  final void Function() onDoubleTap;
  final void Function() onPressedVoltaPagina;
  final void Function() onPressedCapturaCamera;
  final void Function() onPressedTrocaCamera;
  final void Function() onPressedFlash;
  const CorpoCameraWidget({Key? key, required this.childCamera, required this.flashLigado, required this.onDoubleTap, required this.onPressedVoltaPagina, required this.onPressedCapturaCamera, required this.onPressedTrocaCamera, required this.onPressedFlash, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        childCamera,
        BotaoCameraWidget(
          icon: Icons.arrow_back,
          onPressed: onPressedVoltaPagina,
          alignment: Alignment.topLeft,
        ),
        BotaoCameraWidget(
          icon: Icons.camera_alt,
          onPressed: onPressedCapturaCamera,
          alignment: Alignment.bottomCenter,
        ),
        BotaoCameraWidget(
          icon: Icons.cameraswitch,
          onPressed: onPressedTrocaCamera,
          alignment: Alignment.bottomRight,
        ),
        BotaoCameraWidget(
          icon: flashLigado ? Icons.flash_on : Icons.flash_off,
          onPressed: onPressedFlash,
          alignment: Alignment.bottomLeft,
        )
      ],
    );
  }
}
