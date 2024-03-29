import 'dart:io';
import 'package:elephant_control/app/utils/format_numbers.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/text_widget.dart';
import 'package:elephant_control/app/views/stylePages/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerUtil extends StatefulWidget {
  final File videoFile;

  const VideoPlayerUtil({
    Key? key,
    required this.videoFile,
  }) : super(key: key);

  @override
  State<VideoPlayerUtil> createState() => _VideoPlayerUtilState();
}

class _VideoPlayerUtilState extends State<VideoPlayerUtil> {
  late VideoPlayerController controller;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer(){
    controller = VideoPlayerController.file(widget.videoFile);
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value){
      setState(() {});
    });
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.seekTo(Duration(seconds: 0));
        setState(() {});
        await controller.dispose();
        return true;
      },
      child: Scaffold(
        body: Container(
          child: Stack(
            children:[
              Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextWidget(
                        FormatNumbers.formatVideoTime(
                          controller.value.position.inMinutes,
                          controller.value.position.inSeconds,
                        ) +
                        " / " +
                        FormatNumbers.formatVideoTime(
                          controller.value.duration.inMinutes,
                          controller.value.duration.inSeconds,
                        ),
                      ),
                    ),
                    Container(
                      child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors:VideoProgressColors(
                          backgroundColor: AppColors.backgroundPlayColor,
                          playedColor: AppColors.defaultColor,
                          bufferedColor: AppColors.bufferedColor,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              if(controller.value.isPlaying){
                                controller.pause();
                              }
                              else{
                                controller.play();
                              }
                              setState(() {});
                            },
                            icon:Icon(
                              controller.value.isPlaying? Icons.pause: Icons.play_arrow,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              controller.seekTo(Duration(seconds: 0));
                              setState(() {});
                            },
                            icon:Icon(
                              Icons.stop,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}