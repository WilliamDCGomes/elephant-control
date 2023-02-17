import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../enums/enums.dart';
import '../../../../utils/paths.dart';
import '../../../stylePages/app_colors.dart';
import '../../operatorPages/maintenance/page/camera_widget.dart';
import 'information_popup.dart';
import 'package:path/path.dart' as p;

//ignore: must_be_immutable
class ImagesPictureWidget extends StatefulWidget {
  late XFile? picture;
  late imageOrigin origin;
  late ImagesPictureWidgetState imagesPictureWidgetState;

  ImagesPictureWidget({
    Key? key,
    required this.origin,
  }) : super(key: key) {
    picture = null;
  }

  bool checkFileType(String fileName) => fileName.contains('jpg') || fileName.contains('png') || fileName.contains('jpeg');

  CompressFormat _getFormat(String format) {
    switch (format) {
      case "png":
        return CompressFormat.png;
      case "jpeg":
        return CompressFormat.jpeg;
      case "jpg":
        return CompressFormat.jpeg;
    }
    return CompressFormat.jpeg;
  }

  Future<XFile?> compressFile(XFile? file) async {
    try {
      if (file == null) {
        return null;
      }

      final extensaoArquivo = p.extension(file.path);

      if (checkFileType(extensaoArquivo)) {
        var targetPath = file.path.split('.');
        targetPath[targetPath.length - 2] += "_compacted";
        String newPath = "";

        for (int i = 0; i < targetPath.length; i++) {
          if (i != targetPath.length - 1) {
            newPath += (targetPath[i] + ".");
          } else {
            newPath += targetPath[i];
          }
        }

        final imageLowQuality = await FlutterImageCompress.compressAndGetFile(
          file.path,
          newPath,
          quality: 30,
          format: _getFormat(targetPath[targetPath.length - 1]),
        );

        if (imageLowQuality != null) {
          file = XFile(imageLowQuality.path);
        }
      }

      return file;
    } catch (e) {
      return null;
    }
  }

  @override
  State<ImagesPictureWidget> createState() {
    imagesPictureWidgetState = ImagesPictureWidgetState();
    return imagesPictureWidgetState;
  }
}

class ImagesPictureWidgetState extends State<ImagesPictureWidget> {
  refreshPage() {
    if (mounted)
      setState(() {
        widget.picture = widget.picture;
      });
  }

  Future<XFile?> galleryChoice() async {
    try {
      FilePickerResult? image = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png'], allowMultiple: false);
      if (image == null) throw Exception();

      final file = File(image.files.single.path!);
      return XFile(file.path);
    } catch (_) {
      return null;
    }
  }

  Future<XFile?> cameraChoice({bool front = false}) async {
    try {
      File? file = await Get.to(() => CameraWidget(frontal: front));
      if (file == null) throw Exception();
      return XFile(file.path);
    } catch (_) {
      return null;
    }
  }

  _getImage() async {
    try {
      XFile? picture = widget.origin == imageOrigin.camera ? await cameraChoice() : await galleryChoice();

      XFile? pictureCompressed = await widget.compressFile(picture);

      if (pictureCompressed != null) {
        picture = pictureCompressed;
      }

      if (picture != null) {
        setState(() {
          widget.picture = picture;
        });
      }
    } catch (e) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao tirar foto.",
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => await _getImage(),
      child: Container(
        height: 40.w,
        width: 45.w,
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.w),
          ),
          color: AppColors.defaultColor,
        ),
        child: widget.picture == null
            ? Container(
                padding: EdgeInsets.all(3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.w),
                  ),
                  color: AppColors.backgroundColor,
                ),
                child: Image.asset(
                  Paths.Camera,
                  fit: BoxFit.contain,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.w),
                  ),
                  color: AppColors.backgroundColor,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(File(widget.picture!.path).readAsBytesSync()),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.w),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
