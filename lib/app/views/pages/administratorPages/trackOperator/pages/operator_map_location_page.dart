import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/track_operator_controller.dart';

class OperatorMapLocationPage extends StatefulWidget {
  final User operator;

  const OperatorMapLocationPage({
    Key? key,
    required this.operator,
  }) : super(key: key);

  @override
  State<OperatorMapLocationPage> createState() => OperatorMapLocationPageState();
}

class OperatorMapLocationPageState extends State<OperatorMapLocationPage> with TickerProviderStateMixin {
  late TrackOperatorController controller;

  @override
  void initState() {
    controller = Get.find(tag: "track-operator-controller");
    controller.operatorMapLocationPageState = this;
    controller.isInMapScreen = true;
    super.initState();
  }

  @override
  void dispose() {
    controller.isInMapScreen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
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
              Scaffold(
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
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: GetBuilder(
                          init: controller,
                          id: "map-list",
                          builder: (_) => Column(
                            children: [
                              if(controller.userLocationViewController != null)
                                Flexible(
                                  child: FlutterMap(
                                    mapController: controller.mapController,
                                    options: MapOptions(
                                      center: LatLng(
                                        controller.userLocationViewController!.latitudeValue,
                                        controller.userLocationViewController!.longitudeValue,
                                      ),
                                      zoom: 18,
                                    ),
                                    children: [
                                      TileLayer(
                                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        subdomains: ['a', 'b', 'c'],
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: LatLng(
                                              controller.userLocationViewController!.latitudeValue,
                                              controller.userLocationViewController!.longitudeValue,
                                            ),
                                            builder: (_) => Icon(
                                              Icons.pin_drop,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              controller.loadingWithSuccessOrErrorWidget,
            ],
          ),
        ),
      ),
    );
  }
}