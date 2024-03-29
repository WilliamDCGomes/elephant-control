import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../utils/paths.dart';
import '../../../stylePages/app_colors.dart';
import '../loading_with_success_or_error_widget.dart';
import 'information_popup.dart';

//ignore: must_be_immutable
class VideosPictureWidget extends StatefulWidget {
  late String base64;
  late XFile? picture;
  late bool showPlayIcon;
  late LoadingWithSuccessOrErrorWidget? loadingWithSuccessOrErrorWidget;
  late VideosPictureWidgetState videosPictureWidgetState;

  VideosPictureWidget({
    Key? key,
    this.showPlayIcon = false,
    this.loadingWithSuccessOrErrorWidget = null,
  }) : super(key: key){
    picture = null;
  }

  @override
  State<VideosPictureWidget> createState() {
    videosPictureWidgetState = VideosPictureWidgetState();
    return videosPictureWidgetState;
  }
}

class VideosPictureWidgetState extends State<VideosPictureWidget> {
  refreshPage(){
    setState(() {
      widget.picture = widget.picture;
    });
  }

  late final ImagePicker _picker;
  _getVideo() async {
    try{
      if(widget.loadingWithSuccessOrErrorWidget != null){
        await widget.loadingWithSuccessOrErrorWidget!.startAnimation();
      }
      XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxDuration: const Duration(seconds: 30),
      );

      XFile? videoCompressed = await _compressVideo(video);

      if(videoCompressed != null){
        video = videoCompressed;
      }

      if(video != null){
        setState(() {
          widget.picture = video;
        });
      }
      if(widget.loadingWithSuccessOrErrorWidget != null){
        await widget.loadingWithSuccessOrErrorWidget!.stopAnimation(justLoading: true);
      }
    }
    catch(e){
      if(widget.loadingWithSuccessOrErrorWidget != null){
        await widget.loadingWithSuccessOrErrorWidget!.stopAnimation(fail: true);
      }
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao salvar o vídeo.",
          );
        },
      );
    }
  }

  Future<XFile?> _compressVideo(XFile? video) async {
    try{
      if(video == null){
        return null;
      }

      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.LowQuality,
        deleteOrigin: true,
      );

      if(mediaInfo == null || mediaInfo.path == null || mediaInfo.path!.isEmpty){
        return null;
      }

      return XFile(mediaInfo.path!);
    }
    catch(_){
      return null;
    }
  }

  Future<XFile?> getThumbnailFile() async {
    try{
      if(widget.picture != null){
        final fileName = await VideoThumbnail.thumbnailFile(
          video: widget.picture!.path,
          imageFormat: ImageFormat.PNG,
          maxHeight: 100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          quality: 75,
        );
        XFile file = XFile(fileName!);
        return file;
      }
      throw Exception();
    }
    catch(_){
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InformationPopup(
            warningMessage: "Erro ao carregar Thumbnail.",
          );
        },
      );
      return null;
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
      onTap: () async => await _getVideo(),
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
            Paths.Video,
            fit: BoxFit.contain,
            color: AppColors.defaultColor,
          ),
        ) : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.w),
            ),
            color: AppColors.backgroundColor,
          ),
          child: Stack(
            children: [
              FutureBuilder<XFile?>(
                future: getThumbnailFile(),
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot<XFile?> file) {
                  switch(file.connectionState){
                    case ConnectionState.none:
                      return Container();
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.defaultColor,
                        ),
                      );
                    case ConnectionState.active:
                      return Container();
                    case ConnectionState.done:
                      if(file.data != null){
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: MemoryImage(
                                File(
                                  file.data!.path,
                                ).readAsBytesSync(),
                              ),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.w),
                            ),
                          ),
                        );
                      }
                      return Container();
                  }
                },
              ),
              Visibility(
                visible: widget.showPlayIcon,
                child: Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: AppColors.whiteColor,
                    size: 10.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}