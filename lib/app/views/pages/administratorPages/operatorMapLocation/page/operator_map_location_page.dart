import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../base/models/user/user.dart';
import '../controller/operator_map_location_controller.dart';

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
  late OperatorMapLocationController controller;

  @override
  void initState() {
    controller = Get.put(OperatorMapLocationController(widget.operator));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                if(controller.userLocationViewController.value != null)
                  Flexible(
                    child: FlutterMap(
                      options: MapOptions(
                          center: LatLng(
                            controller.userLocationViewController.value!.longitudeValue,
                            controller.userLocationViewController.value!.latitudeValue,
                          ),
                          zoom: 8
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
                                controller.userLocationViewController.value!.longitudeValue,
                                controller.userLocationViewController.value!.latitudeValue,
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
    );
  }
}