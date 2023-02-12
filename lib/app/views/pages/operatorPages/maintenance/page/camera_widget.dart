import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'botao_camera_widget.dart';
import 'camera_button_widget.dart';
import 'camera_widget_controller.dart';
import 'corpo_camera_widget.dart';

class CameraWidget extends StatefulWidget {
  final bool frontal;
  const CameraWidget({Key? key, this.frontal = false}) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> with WidgetsBindingObserver {
  late CameraWidgetController controller;

  @override
  void initState() {
    controller = Get.put(CameraWidgetController(widget.frontal));
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (controller.cameraController == null || !controller.cameraController!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      controller.cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed && controller.cameraController != null) {
      var camera = await controller.abrirCamera(onResume: true);
      if (mounted) {
        setState(() {
          camera;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.cameraController?.dispose();
    controller.cameraController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: IgnorePointer(
            ignoring: !controller.permiteAcao,
            child: Obx(() => Visibility(
                  visible: controller.estaCarregando.value,
                  child: const CircularProgressIndicator(),
                  replacement: Visibility(
                    visible: controller.tiraFoto.value,
                    child: CorpoCameraWidget(
                        childCamera: controller.cameraController == null
                            ? Center(child: const CircularProgressIndicator())
                            : GestureDetector(
                                onDoubleTap: () async {},
                                child: SizedBox(
                                  height: 100.h,
                                  width: double.infinity,
                                  child: CameraPreview(controller.cameraController!),
                                ),
                              ),
                        flashLigado: controller.flashLigado.value,
                        onDoubleTap: () async => await controller.abrirCamera(),
                        onPressedVoltaPagina: () => controller.retornarTela(),
                        onPressedCapturaCamera: () async => await controller.btnCapturarCamera(),
                        onPressedTrocaCamera: () async => await controller.btnTrocarCamera(),
                        onPressedFlash: () async => await controller.btnFlashCamera()),
                    replacement: Obx(
                      () => !controller.temFoto.value
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                Flexible(
                                  child: Stack(
                                    children: [
                                      Image.file(
                                        controller.foto!,
                                        fit: BoxFit.fill,
                                        height: 90.h,
                                        width: 100.w,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          BotaoCameraWidget(
                                            icon: Icons.arrow_back,
                                            onPressed: controller.retornarTela,
                                            alignment: Alignment.topLeft,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      CameraButtonWidget(
                                          textoBotao: "NOVA FOTO",
                                          onPressed: () async => await controller.onPressedNovaFoto()),
                                      CameraButtonWidget(
                                          textoBotao: "ESCOLHER", onPressed: () => Get.back(result: controller.foto))
                                    ],
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                )),
          ),
        ));
  }
}
