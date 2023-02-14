import 'package:carousel_slider/carousel_slider.dart';
import 'package:elephant_control/app/utils/logged_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/app_close_controller.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../sharedPages/userProfile/page/user_profile_page.dart';
import '../../../widgetsShared/profile_picture_widget.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../financialHistoryAdministrator/page/financial_history_administrator_page.dart';
import '../../machine/page/machine_page.dart';
import '../../newReminder/page/new_reminder_page.dart';
import '../../operatorFinancialPouch/page/operator_financial_pouch_page.dart';
import '../../operatorsVisits/page/operators_visits_page.dart';
import '../../recallMoney/page/recall_money_page.dart';
import '../../report/page/report_page.dart';
import '../../stockControl/page/stock_control_page.dart';
import '../../users/page/user_page.dart';
import '../controller/main_menu_administrator_controller.dart';
import '../widgets/menu_options_widget.dart';

class MainMenuAdministratorAfterLoadWidget extends StatefulWidget {
  final bool accessValidate;
  const MainMenuAdministratorAfterLoadWidget({Key? key, required this.accessValidate}) : super(key: key);

  @override
  State<MainMenuAdministratorAfterLoadWidget> createState() => _MainMenuAdministratorAfterLoadWidgetState();
}

class _MainMenuAdministratorAfterLoadWidgetState extends State<MainMenuAdministratorAfterLoadWidget> {
  late MainMenuAdministratorController controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        controller.activeStep = 0;
      });
    });
    controller = Get.find(tag: "main_menu_administrator_controller");
    super.initState();
  }

  bool get accessValidate => widget.accessValidate;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return AppCloseController.verifyCloseScreen();
      },
      child: SafeArea(
        child: Material(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.backgroundFirstScreenColor,
              ),
            ),
            child: Scaffold(
              backgroundColor: AppColors.transparentColor,
              body: Column(
                children: [
                  Container(
                    color: AppColors.defaultColor,
                    padding: EdgeInsets.only(left: 2.h, top: 1.h, right: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButtonWidget(
                          onTap: () => Get.to(() => UserProfilePage(
                                mainMenuAdministratorController: controller,
                              )),
                          borderRadius: 1.h,
                          componentPadding: EdgeInsets.zero,
                          widgetCustom: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 3.w),
                                child: Container(
                                  height: 6.5.h,
                                  width: 6.5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.25.h),
                                  ),
                                  child: Center(
                                    child: ProfilePictureWidget(
                                      fontSize: 18.sp,
                                      hasPicture: controller.hasPicture,
                                      loadingPicture: controller.loadingPicture,
                                      profileImagePath: controller.profileImagePath,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      "Olá, ${controller.nameProfile}",
                                      textColor: AppColors.backgroundColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                      textAlign: TextAlign.start,
                                    ),
                                    TextWidget(
                                      controller.welcomePhrase.value,
                                      textColor: AppColors.backgroundColor,
                                      fontSize: 17.sp,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          Paths.Logo_Cor_Background,
                          width: 35.w,
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 20.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.h)),
                          color: AppColors.defaultColor,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 3.h),
                              child: Center(
                                child: TextWidget(
                                  "CENTRAL ADMINISTRATIVA",
                                  textColor: AppColors.backgroundColor,
                                  fontSize: 22.sp,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Obx(
                          () => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5.h, bottom: 1.h),
                                child: CarouselSlider.builder(
                                  carouselController: controller.carouselController,
                                  itemCount: controller.cardMainMenuAdministratorList.length,
                                  options: CarouselOptions(
                                      viewportFraction: 1,
                                      height: 30.h,
                                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                      onPageChanged: (itemIndex, reason) {
                                        setState(() {
                                          controller.activeStep = itemIndex;
                                        });
                                      }),
                                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                                    return controller.cardMainMenuAdministratorList[itemIndex];
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 1.h),
                                child: DotStepper(
                                  dotCount: controller.cardMainMenuAdministratorList.length > 1
                                      ? controller.cardMainMenuAdministratorList.length
                                      : 2,
                                  dotRadius: 1.h,
                                  activeStep: controller.activeStep,
                                  shape: Shape.stadium,
                                  spacing: 3.w,
                                  indicator: Indicator.magnify,
                                  fixedDotDecoration: FixedDotDecoration(
                                    color: AppColors.grayStepColor,
                                  ),
                                  indicatorDecoration: IndicatorDecoration(
                                    color: AppColors.defaultColor,
                                  ),
                                  onDotTapped: (tappedDotIndex) {
                                    setState(() {
                                      controller.activeStep = tappedDotIndex;
                                      controller.carouselController.jumpToPage(tappedDotIndex);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1.h,
                      ),
                      padding: EdgeInsets.all(2.h),
                      children: [
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("MalotesComOperadores")))
                          MenuOptionsWidget(
                            text: "Malotes com Operadores",
                            imagePath: Paths.Malote,
                            onTap: () => Get.to(
                              () => OperatorFinancialPouchPage(
                                withOperator: true,
                              ),
                            ),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("VisitasOperadores")))
                          MenuOptionsWidget(
                            text: "Visitas dos Operadores",
                            imagePath: Paths.Manutencao,
                            onTap: () => Get.to(() => OperatorsVisitsPage()),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("HistoricoCofreTesouraria")))
                          MenuOptionsWidget(
                            text: "Histórico Cofre da Tesouraria",
                            imagePath: Paths.Cofre,
                            onTap: () => Get.to(() => FinancialHistoryAdministratorPage()),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("MalotesTesouraria")))
                          MenuOptionsWidget(
                            text: "Malotes com Tesouraria",
                            imagePath: Paths.Malote_Com_Tesouraria,
                            onTap: () => Get.to(() => OperatorFinancialPouchPage(
                                  withOperator: false,
                                )),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("Usuarios")))
                          MenuOptionsWidget(
                            text: "Usuários",
                            imagePath: Paths.Novo_Usuario,
                            onTap: () => Get.to(() => UserPage()),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("Maquinas")))
                          MenuOptionsWidget(
                            text: "Máquinas",
                            imagePath: Paths.Maquina_Pelucia,
                            onTap: () => Get.to(() => MachinePage()),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("NovoLembrete")))
                          MenuOptionsWidget(
                            text: "Novo Lembrete",
                            imagePath: Paths.Novo_Lembrete,
                            onTap: () => Get.to(() => NewReminderPage()),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("RecolherDinheiro")))
                          MenuOptionsWidget(
                            text: "Recolher Dinheiro",
                            imagePath: Paths.Recolher_Dinheiro,
                            onTap: () => Get.to(() => RecallMoneyPage()),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("Relatorio")))
                          MenuOptionsWidget(
                            text: "Relatórios",
                            imagePath: Paths.Relatorio,
                            onTap: () => Get.to(() => ReportPage()),
                          ),
                        if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("Estoque")))
                          MenuOptionsWidget(
                            text: "Estoque",
                            imagePath: Paths.Pelucia,
                            onTap: () => Get.to(() => StockControlPage()),
                          ),
                        /*if (!accessValidate || (accessValidate && LoggedUser.nameRoles.contains("Solicitacoes")))
                          MenuOptionsWidget(
                            text: "Solicitações",
                            imagePath: Paths.Solicitacoes,
                            disable: true,
                            onTap: () {},
                          ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}