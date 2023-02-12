import 'package:elephant_control/app/utils/date_format_to_brazil.dart';
import 'package:elephant_control/app/views/pages/widgetsShared/maintenance_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/map_utils.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/information_container_widget.dart';
import '../../../widgetsShared/popups/bottom_sheet_popup.dart';
import '../../../widgetsShared/popups/confirmation_popup.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../../widgetsShared/title_with_back_button_widget.dart';
import '../controller/maintenance_history_controller.dart';
import '../popups/maintenance_information_popup.dart';

class MaintenanceHistoryAfterLoadWidget extends StatefulWidget {
  const MaintenanceHistoryAfterLoadWidget({Key? key}) : super(key: key);

  @override
  State<MaintenanceHistoryAfterLoadWidget> createState() => _MaintenanceHistoryAfterLoadWidgetState();
}

class _MaintenanceHistoryAfterLoadWidgetState extends State<MaintenanceHistoryAfterLoadWidget> {
  late MaintenanceHistoryController controller;

  @override
  void initState() {
    Get.delete<MaintenanceHistoryController>();
    controller = Get.find(tag: "maintenance-history-controller");
    super.initState();
  }

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
                        child: TitleWithBackButtonWidget(
                          title: "Visitas",
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InformationContainerWidget(
                              iconPath: Paths.Pelucia,
                              textColor: AppColors.whiteColor,
                              backgroundColor: AppColors.defaultColor,
                              informationText: "",
                              customContainer: TextWidget(
                                "Visitas do dia: ${DateFormatToBrazil.formatDate(DateTime.now())}",
                                textColor: AppColors.whiteColor,
                                fontSize: 18.sp,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Obx(
                                () => Visibility(
                                  visible: controller.visits.isNotEmpty,
                                  replacement: Center(
                                    child: TextWidget(
                                      "Nenhuma visita encontrada",
                                      textColor: AppColors.blackColor,
                                    ),
                                  ),
                                  child: ListView.builder(
                                    itemCount: controller.visits.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                                    itemBuilder: (context, index) {
                                      final visit = controller.visits[index];
                                      return Stack(
                                        children: [
                                          MaintenanceCardWidget(
                                            onTapDesabilitate: (visit.active == true && visit.realizedVisit == true),
                                            machineName: visit.machineName,
                                            decoratorLine: visit.active == false,
                                            city: "",
                                            status: visit.status?.description ?? "Pendente",
                                            workPriority: "NORMAL",
                                            priorityColor: AppColors.greenColor.value,
                                            clock1: visit.moneyQuantity.toString(),
                                            clock2: visit.stuffedAnimalsQuantity.toString(),
                                            teddy: visit.stuffedAnimalsReplaceQuantity.toString(),
                                            pouchCollected: visit.moneyPouchRetired,
                                            showRadius: false,
                                            setHeight: false,
                                            machineAddOtherList: visit.active == false,
                                            visitId: visit.id ?? "",
                                            visitDate: visit.inclusion ?? DateTime.now(),
                                            onTap: () async {
                                              if ((visit.active == true && visit.realizedVisit == true)) {
                                                await BottomSheetPopup.showAlert(
                                                  context,
                                                  MaintenanceInformationPopup.getWidgetList(
                                                    context,
                                                    visit.machineName,
                                                    visit.moneyQuantity.toString(),
                                                    visit.stuffedAnimalsQuantity.toString(),
                                                    visit.stuffedAnimalsReplaceQuantity.toString(),
                                                    visit.status?.description ?? "Pendente",
                                                    "NORMAL",
                                                    AppColors.greenColor.value,
                                                    visit.moneyPouchRetired,
                                                    visit.responsibleName,
                                                    visit.id ?? "",
                                                    visit.inclusion ?? DateTime.now(),
                                                    controller,
                                                    offline: controller.offline,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible: visit.latitude != null &&
                                                      visit.latitude != "" &&
                                                      visit.longitude != null &&
                                                      visit.longitude != "",
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () => MapUtils.openMap(
                                                        double.tryParse((visit.latitude ?? "").replaceAll(',', '.')),
                                                        double.tryParse((visit.longitude ?? "").replaceAll(',', '.')),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: .2.h, vertical: 1.h),
                                                        child: Icon(
                                                          Icons.map,
                                                          color: AppColors.whiteColor,
                                                          size: 3.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: visit.realizedVisit == false && visit.active == true,
                                                  replacement: SizedBox(
                                                    width: .8.h,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(1.h),
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () async => await showDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (BuildContext context) {
                                                            return ConfirmationPopup(
                                                              title: "Aviso",
                                                              subTitle:
                                                                  "Tem certeza que deseja apagar essa máquina das suas visitas pendentes?",
                                                              firstButton: () {},
                                                              secondButton: () async =>
                                                                  await controller.deleteOrUndeleteVisitDay(visit),
                                                            );
                                                          },
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: AppColors.backgroundColor,
                                                          size: 3.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 2.h),
                              child: ButtonWidget(
                                hintText: "Adicionar máquina para a visita",
                                fontWeight: FontWeight.bold,
                                widthButton: double.infinity,
                                onPressed: () async => controller.newItem(),
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
