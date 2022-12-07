import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../utils/paths.dart';
import '../../../stylePages/app_colors.dart';
import 'information_popup.dart';

class ImagesPictureWidget extends StatefulWidget {
  late XFile? picture;

  ImagesPictureWidget({
    Key? key,
  }) : super(key: key){
    picture = null;
  }

  @override
  State<ImagesPictureWidget> createState() => _ImagesPictureWidgetState();
}

class _ImagesPictureWidgetState extends State<ImagesPictureWidget> {
  late final ImagePicker _picker;
  _getImage() async {
    try{
      widget.picture = await _picker.pickImage(
        source: ImageSource.camera
      );

      setState(() {
        widget.picture;
      });
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