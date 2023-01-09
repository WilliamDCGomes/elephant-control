import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import '../../../widgetsShared/shimmer/default_shimmer.dart';
import '../controller/user_controller.dart';
import '../widget/user_after_load_widget.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final UserController controller;
  @override
  void initState() {
    controller = Get.put(UserController(), tag: "user-controller");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => controller.screenLoading.value ?
        DefaultShimmer(
          pageTitle: "Usuários",
          mainCardSize: 3.h,
          cardsSize: 10.h,
        ) :
        UserAfterLoadWidget(),
      ),
    );
  }
}
