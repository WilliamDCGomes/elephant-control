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
  State<OperatorMapLocationPage> createState() => _OperatorMapLocationPageState();
}

class _OperatorMapLocationPageState extends State<OperatorMapLocationPage> {
  late TrackOperatorController controller;

  @override
  void initState() {
    controller = Get.find(tag: "track-operator-controller");
    super.initState();
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
                          id: "map_view",
                          builder: (_) => Column(
                            children: [
                              if(controller.userLocationViewController.value != null)
                                Flexible(
                                  child: FlutterMap(
                                    options: MapOptions(
                                      center: LatLng(
                                        controller.userLocationViewController.value!.latitudeValue,
                                        controller.userLocationViewController.value!.longitudeValue,
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
                                              controller.userLocationViewController.value!.latitudeValue,
                                              controller.userLocationViewController.value!.longitudeValue,
                                            ),
                                            builder: (_) => Icon(
                                              Icons.pin_drop,
                                            ),
                                          )
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