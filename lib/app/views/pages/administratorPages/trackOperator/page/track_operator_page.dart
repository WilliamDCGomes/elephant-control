import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/track_operator_controller.dart';
import '../widgets/operator_map_location_widget.dart';
import '../widgets/track_operator_widget.dart';

class TrackOperatorPage extends StatefulWidget {
  final User operator;

  const TrackOperatorPage({
    Key? key,
    required this.operator,
  }) : super(key: key);

  @override
  State<TrackOperatorPage> createState() => TrackOperatorPageState();
}

class TrackOperatorPageState extends State<TrackOperatorPage> with TickerProviderStateMixin {
  late TrackOperatorController controller;

  @override
  void initState() {
    controller = Get.put(
      TrackOperatorController(widget.operator, this),
      tag: "track-operator-controller",
    );
    controller.initializeVariableAsync();
    super.initState();
  }

  void animatedMapMove(LatLng destLocation) {
    final latTween = Tween<double>(
      begin: controller.mapController.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: controller.mapController.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: controller.mapController.zoom,
      end: 18,
    );

    final animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );

    animationController.addListener(() {
      controller.mapController.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            return await controller.returnScreen();
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.backgroundFirstScreenColor,
                ),
              ),
              child: Stack(
                children: [
                  Obx(
                    () => Scaffold(
                      backgroundColor: AppColors.transparentColor,
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 8.h,
                            color: AppColors.defaultColor,
                            padding: EdgeInsets.symmetric(horizontal: 2.h),
                            child: TitleWithBackButtonWidget(
                              title: "Localização do Operador",
                              backButtonPressedFuctionOverride: () => controller.titleScreenTapped(),
                            ),
                          ),
                          Expanded(
                            child: Visibility(
                              visible: controller.showMap.value,
                              replacement: TrackOperatorWidget(),
                              child: OperatorMapLocationWidget(),
                            ),
                          ),
                        ],
                      ),
                      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                      floatingActionButton: !controller.showMap.value ?
                      FloatingActionButton.extended(
                        backgroundColor: AppColors.defaultColor,
                        foregroundColor: AppColors.backgroundColor,
                        elevation: 3,
                        label: TextWidget(
                          "Mostrar no Mapa",
                          maxLines: 1,
                          textColor: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => controller.openMap(),
                      ) : null,
                    ),
                  ),
                  controller.loadingWithSuccessOrErrorWidget,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
