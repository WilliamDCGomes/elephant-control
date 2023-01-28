import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/text_field_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/maintenance_history_controller.dart';

class AppNewMaintenanceAfterLoadWidget extends StatefulWidget {
  final String title;
  final MaintenanceHistoryController controller;

  const AppNewMaintenanceAfterLoadWidget({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  State<AppNewMaintenanceAfterLoadWidget> createState() => _AppNewMaintenanceAfterLoadWidgetState();
}

class _AppNewMaintenanceAfterLoadWidgetState extends State<AppNewMaintenanceAfterLoadWidget> {
  @override
  void dispose() {
    Future.microtask(() async => await controller.getVisitsOperatorByUserId(showLoad: false));
    super.dispose();
  }

  MaintenanceHistoryController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
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
                Scaffold(
                  backgroundColor: AppColors.transparentColor,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        color: AppColors.defaultColor,
                        padding: EdgeInsets.symmetric(horizontal: 2.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: TitleWithBackButtonWidget(
                                title: "Visitas Pendentes",
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            InkWell(
                              //onTap: () => widget.controller.callFilterMaintenanceList(),
                              child: Icon(
                                Icons.filter_alt,
                                color: AppColors.whiteColor,
                                size: 3.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Pelucia,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    "Selecione uma das máquinas para adicionar a sua lista",
                                    textColor: AppColors.whiteColor,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 0),
                              child: TextFieldWidget(
                                controller: controller.searchMachines,
                                hintText: "Pesquisar Máquinas",
                                height: 9.h,
                                width: double.infinity,
                                onChanged: (value) => controller.updateList(),
                                iconTextField: Icon(
                                  Icons.search,
                                  color: AppColors.defaultColor,
                                  size: 3.h,
                                ),
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: Obx(
                                      () => Visibility(
                                    visible: controller.machines.isNotEmpty,
                                    replacement: Center(
                                      child: TextWidget(
                                        "Nenhuma máquina encontrada",
                                        textColor: AppColors.blackColor,
                                      ),
                                    ),
                                    child: ListView.builder(
                                      itemCount: controller.machines.length, //TODO widget.controller.allMaintenanceCardWidgetFilteredList.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                                      itemBuilder: (context, index) {
                                        final machine = controller.machines[index];
                                        return InkWell(
                                          onTap: () async {
                                            await showDialog(
                                              context: Get.context!,
                                              builder: (BuildContext context) {
                                                return ConfirmationPopup(
                                                  title: "Aviso",
                                                  subTitle: "Deseja realmente adicionar a máquina ${widget.controller.machines[index].name} na sua lista de atendimentos?",
                                                  firstButton: () {},
                                                  secondButton: () async => await controller.createuserMachine(machine.id!),
                                                );
                                              },
                                            );
                                          },
                                          child: IgnorePointer(
                                            ignoring: true,
                                            child: MaintenanceCardWidget(
                                              machineName: machine.name,
                                              city: machine.city,
                                              machineAddOtherList: machine.machineAddOtherList ?? false,
                                              status: "Pendente",
                                              workPriority: "NORMAL",
                                              priorityColor: AppColors.greenColor.value,
                                              showRadius: false,
                                              setHeight: false,
                                              clock1: "0",
                                              clock2: "0",
                                              teddy: "0",
                                              pouchCollected: false,
                                              visitId: "",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
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
                controller.loadingWithSuccessOrErrorWidgetTwo,
              ],
            ),
          ),
        ),
      ),
    );
  }
}