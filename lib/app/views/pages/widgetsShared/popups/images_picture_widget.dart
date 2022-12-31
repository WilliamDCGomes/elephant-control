import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../enums/enums.dart';
import '../../../../utils/paths.dart';
import '../../../stylePages/app_colors.dart';
import 'information_popup.dart';
import 'package:path/path.dart' as p;

//ignore: must_be_immutable
class ImagesPictureWidget extends StatefulWidget {
  late XFile? picture;
  late imageOrigin origin;

  ImagesPictureWidget({
    Key? key,
    required this.origin,
  }) : super(key: key){
    picture = null;
  }

  bool checkFileType(String fileName) => fileName.contains('jpg') || fileName.contains('png') || fileName.contains('jpeg');

  Future<XFile?> compressFile(XFile? file) async {
    try {
      if(file == null){
        return null;
      }

      final extensaoArquivo = p.extension(file.path);

      if (checkFileType(extensaoArquivo)) {
        final imageLowQuality = await FlutterImageCompress.compressAndGetFile(
          file.path,
          file.path,
          quality: 30,
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
  State<ImagesPictureWidget> createState() => _ImagesPictureWidgetState();
}

class _ImagesPictureWidgetState extends State<ImagesPictureWidget> {
  late final ImagePicker _picker;
  _getImage() async {
    try{
      XFile? picture = await _picker.pickImage(
        source: widget.origin == imageOrigin.camera ?
        ImageSource.camera : ImageSource.gallery,
        preferredCameraDevice: CameraDevice.rear,
      );

      picture = await widget.compressFile(picture);

      if(picture != null){
        setState(() {
          widget.picture = picture;
        });
      }
    }
    catch(e){
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
  void initState() {
    _picker = ImagePicker();
    super.initState();
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
        child: widget.picture == null ? Container(
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
        ) : Container(
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