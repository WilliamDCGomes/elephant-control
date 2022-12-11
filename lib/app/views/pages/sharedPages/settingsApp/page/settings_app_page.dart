import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/settings_app_controller.dart';

class SettingsAppPage extends StatefulWidget {
  const SettingsAppPage({Key? key}) : super(key: key);

  @override
  State<SettingsAppPage> createState() => _SettingsAppPageState();
}

class _SettingsAppPageState extends State<SettingsAppPage> {
  late SettingsAppController controller;

  @override
  void initState() {
    controller = Get.put(SettingsAppController());

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 8.h,
                      color: AppColors.defaultColor,
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: TitleWithBackButtonWidget(
                        title: "Configurações",
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InformationContainerWidget(
                            iconPath: Paths.Icone_Configuracao,
                            textColor: AppColors.whiteColor,
                            backgroundColor: AppColors.defaultColor,
                            informationText: "Configurações do Aplicativo",
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.h),
                              child: Obx(
                                () => ListView.builder(
                                  itemCount: controller.cardSettingsList.length,
                                  itemBuilder: (context, index){
                                    return Container(
                                      key: Key("$index"),
                                      child: controller.cardSettingsList[index],
                                    );
                                  },
                                ),
                              ),
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
