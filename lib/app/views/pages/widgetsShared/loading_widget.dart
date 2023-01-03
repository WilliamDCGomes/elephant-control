import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../utils/paths.dart';
import '../../stylePages/app_colors.dart';
import 'lottie_asset_widget.dart';

class LoadingWidget extends StatefulWidget {
  late final RxBool loadingAnimation;
  late final AnimationController animationController;

  LoadingWidget(
      {
        Key? key,
        RxBool? internalLoadingAnimation,
      }) : super(key: key){
    loadingAnimation = internalLoadingAnimation ?? false.obs;
  }

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();

  Future startAnimation({Widget? destinationPage, bool? backPage}) async {
    loadingAnimation.value = true;
    animationController.repeat();
  }

  Future stopAnimation({Widget? destinationPage, bool? backPage, bool? justLoading}) async {
    loadingAnimation.value = true;
    if(justLoading != null && justLoading){
      await Future.delayed(Duration(seconds: 1));
      _resetState();
      return;
    }
    else if(destinationPage != null) {
      await Future.delayed(Duration(seconds: 3));
      Get.offAll(() => destinationPage);
    }
    else if(backPage != null && backPage){
      await Future.delayed(Duration(seconds: 3));
      Get.back();
    }
    else{
      await Future.delayed(Duration(seconds: 3));
    }
    _resetState();
  }

  _resetState(){
    loadingAnimation.value = false;
    animationController.reset();
  }
}

class _LoadingWidgetState extends State<LoadingWidget> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.animationController = AnimationController(vsync: this);
    widget.animationController.duration = Duration(seconds: 3);
    super.initState();
  }

  @override
  void dispose() {
    widget.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        return !widget.loadingAnimation.value;
      },
      child: Obx(
        () => Visibility(
          visible: widget.loadingAnimation.value,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 100.h,
              width: 100.w,
              color: AppColors.blackTransparentColor,
              child: Center(
                child: LottieAssetWidget(
                  animationPath: Paths.Loading,
                  animationController: widget.animationController,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}