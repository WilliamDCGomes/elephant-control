import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'camera_button_widget.dart';

class FotoPdfWidget extends StatelessWidget {
  final Function(int)? onPressedSubstituirFoto;
  final Function()? onPressedAdicionarFoto;
  final Widget conteudo;
  final int index;
  final bool solicitacao;
  const FotoPdfWidget(
      {Key? key,
      this.onPressedSubstituirFoto,
      required this.onPressedAdicionarFoto,
      required this.conteudo,
      required this.index,
      this.solicitacao = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: conteudo,
        ),
        Row(
          children: [
            Visibility(
              visible: onPressedSubstituirFoto != null,
              child: Expanded(
                child: CameraButtonWidget(
                  solicitacao: solicitacao,
                  textoBotao: "SUBSTITUIR ARQUIVO",
                  onPressed: () async {
                    Get.back(result: await onPressedSubstituirFoto?.call(index));
                  },
                ),
              ),
            ),
            Visibility(
              visible: onPressedAdicionarFoto != null,
              child: Expanded(
                child: CameraButtonWidget(
                  solicitacao: solicitacao,
                  textoBotao: "ADICIONAR ARQUIVO",
                  onPressed: () async {
                    Get.back(result: await onPressedAdicionarFoto?.call());
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
