import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controller/track_operator_controller.dart';

class OperatorMapLocationWidget extends StatefulWidget {
  const OperatorMapLocationWidget({Key? key}) : super(key: key);

  @override
  State<OperatorMapLocationWidget> createState() => _OperatorMapLocationWidgetState();
}

class _OperatorMapLocationWidgetState extends State<OperatorMapLocationWidget> {
  late TrackOperatorController controller;

  @override
  void initState() {
    controller = Get.find(tag: "track-operator-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
