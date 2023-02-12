import 'dart:io';
import 'package:camera/camera.dart';
import 'package:elephant_control/app/views/pages/operatorPages/maintenance/page/permissao_camera_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:collection/collection.dart';

class CameraWidgetController extends GetxController with WidgetsBindingObserver {
  File? foto;
  CameraController? cameraController;
  late RxBool tiraFoto;
  late RxBool temFoto;
  late RxBool flashLigado;
  late RxBool estaCarregando;
  late bool permiteAcao;
  late bool frontal;
  late Future<void> initializeControllerFuture;
  late List<CameraDescription> cameras;
  late GlobalKey canvasKey;
  late GlobalKey globalKey;

  CameraWidgetController(this.frontal) {
    tiraFoto = true.obs;
    temFoto = false.obs;
    flashLigado = false.obs;
    estaCarregando = false.obs;
    permiteAcao = true;
    canvasKey = GlobalKey();
    globalKey = GlobalKey();
  }

  @override
  Future<void> onInit() async {
    getImage();
    super.onInit();
  }

  Future<void> getImage() async {
    try {
      PermissionStatus status = await Permission.camera.status;
      if (status.isGranted) {
        permiteAcao = false;
        temFoto.value = false;
        tiraFoto.value = await abrirCamera(frontal: frontal);
      } else {
        PermissionStatus status = await Permission.camera.request();
        if (status.isPermanentlyDenied) {
          await showDialog<String>(context: Get.context!, builder: (BuildContext context) => const PermissaoCamera());
        } else if (status.isDenied) {
          Permission.camera.request();
        } else if (status.isGranted) {
          await getImage();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> btnTrocarCamera() async {
    tiraFoto.value = false;
    tiraFoto.value = await abrirCamera();
  }

  Future<void> btnCapturarCamera() async {
    await tirarFoto();
  }

  Future<void> btnFlashCamera() async {
    flashLigado.value = !flashLigado.value;
  }

  retornarTela() {
    cameraController?.dispose();
    cameraController = null;
    Get.back(result: null);
  }

  onPressedNovaFoto() async {
    cameraController?.dispose();
    cameraController = null;
    await getImage();
  }

  Future abrirCamera({bool frontal = false, bool onResume = false}) async {
    try {
      cameras = await availableCameras();
      //Caso a lista de câmeras vier vazia gera uma excessão para ir ao catch
      if (cameras.isEmpty) throw Exception();
      //Valor padrão da orientação é traseiro
      CameraLensDirection orientacaoCamera = CameraLensDirection.back;
      //Define se a câmera abrirá no modo frontal
      //Valida se a câmera está inicializada e se a orientação é traseiro ou se é para abrir a câmera frontal
      if ((cameraController != null &&
              cameraController!.value.isInitialized &&
              cameraController!.description.lensDirection == CameraLensDirection.back &&
              !onResume) ||
          frontal) {
        orientacaoCamera = orientacaoCamera = CameraLensDirection.front;
      } else if (cameraController != null && cameraController!.value.isInitialized && onResume) {
        orientacaoCamera = cameraController!.description.lensDirection;
      }
      //Retorna a câmera para o usuário, mandando orientaçãoCamera para definir a orientação
      CameraDescription? camera = cameras.firstWhereOrNull((element) => element.lensDirection == orientacaoCamera);
      camera ??= cameras.first;
      permiteAcao = true;
      await _previewCamera(camera);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _previewCamera(CameraDescription camera) async {
    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    try {
      return await cameraController?.initialize();
    } on CameraException catch (e) {
      if (kDebugMode) {
        print(e.description);
      }
      return null;
    }
  }

  String getPath(File file) {
    String path = file.absolute.path;
    int index = path.lastIndexOf("/");
    return path.substring(0, index) + "/temp.jpg";
  }

  Future<void> tirarFoto({bool flash = true}) async {
    estaCarregando.value = true;
    final CameraController? _cameraController = cameraController;

    if (_cameraController != null && _cameraController.value.isInitialized) {
      try {
        if (flash)
          flashLigado.value
              ? await cameraController?.setFlashMode(FlashMode.torch)
              : await cameraController?.setFlashMode(FlashMode.off);
        // if (flashLigado.value) await cameraController?.setFlashMode(FlashMode.torch);
        XFile file = await _cameraController.takePicture();
        File fileParaConversao = File(file.path);
        foto = await FlutterImageCompress.compressAndGetFile(fileParaConversao.absolute.path, getPath(fileParaConversao),
            quality: 50);
        if (flashLigado.value) await cameraController?.setFlashMode(FlashMode.always);
        foto = File(file.path);
        tiraFoto.value = false;
        temFoto.value = true;
        permiteAcao = true;
      } on CameraException catch (e) {
        if (e.code == 'setFlashModeFailed') return tirarFoto(flash: false);
        debugPrint(e.description);
      } finally {
        estaCarregando.value = false;
      }
    }
  }
}
