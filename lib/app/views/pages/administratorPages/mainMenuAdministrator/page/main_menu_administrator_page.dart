import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../utils/app_close_controller.dart';
import '../../../../../utils/paths.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../machine/page/machine_page.dart';
import '../../../sharedPages/userProfile/page/user_profile_page.dart';
import '../../../widgetsShared/profile_picture_widget.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../financialHistoryAdministrator/page/financial_history_administrator_page.dart';
import '../../operatorFinancialPouch/page/operator_financial_pouch_page.dart';
import '../../operatorsVisits/page/operators_visits_page.dart';
import '../../registerMachine/page/register_machine_page.dart';
import '../../registerUsers/page/register_user_page.dart';
import '../controller/main_menu_administrator_controller.dart';
import '../widget/menu_options_widget.dart';

class MainMenuAdministratorPage extends StatefulWidget {
  const MainMenuAdministratorPage({Key? key}) : super(key: key);

  @override
  State<MainMenuAdministratorPage> createState() => _MainMenuAdministratorPageState();
}

class _MainMenuAdministratorPageState extends State<MainMenuAdministratorPage> {
  late MainMenuAdministratorController controller;

  @override
  void initState() {
    controller = Get.put(MainMenuAdministratorController(), tag: "main_menu_administrator_controller");
    super.initState();
  }

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
                    height: 30.h,
                    width: 100.w,
                    padding: EdgeInsets.only(top: 1.5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.h)),
                      color: AppColors.defaultColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.h),
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
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
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
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1.h,
                      ),
                      padding: EdgeInsets.all(2.h),
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //   ],
                        // ),

                        MenuOptionsWidget(
                          text: "Malotes com Operadores",
                          imagePath: Paths.Malote,
                          onTap: () => Get.to(() => OperatorFinancialPouchPage(
                                withOperator: true,
                              )),
                        ),
                        MenuOptionsWidget(
                          text: "Visitas dos Operadores",
                          imagePath: Paths.Manutencao,
                          onTap: () => Get.to(() => OperatorsVisitsPage()),
                        ),
                        MenuOptionsWidget(
                          text: "Histórico Cofre da Tesouraria",
                          imagePath: Paths.Cofre,
                          onTap: () => Get.to(() => FinancialHistoryAdministratorPage()),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 2.h),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //     ],
                        //   ),
                        // ),

                        MenuOptionsWidget(
                          text: "Malotes com Tesouraria",
                          imagePath: Paths.Malote_Com_Tesouraria,
                          onTap: () => Get.to(() => OperatorFinancialPouchPage(
                                withOperator: false,
                              )),
                        ),
                        MenuOptionsWidget(
                          text: "Novo Usuário",
                          imagePath: Paths.Novo_Usuario,
                          onTap: () => Get.to(() => RegisterUsersPage()),
                        ),
                        MenuOptionsWidget(
                          text: "Máquinas",
                          imagePath: Paths.Maquina_Pelucia,
                          onTap: () => Get.to(() => MachinePage()),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 2.h),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       MenuOptionsWidget(
                        //         text: "Máquina x Usuário",
                        //         imagePath: Paths.Maquina_Pelucia,
                        //         onTap: () => Get.to(() => RegisterUserMachinePage()),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 2.h),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //     ],
                        //   ),
                        // ),

                        MenuOptionsWidget(
                          text: "Novo Lembrete",
                          imagePath: Paths.Novo_Lembrete,
                          disable: true,
                          onTap: () {},
                        ),
                        MenuOptionsWidget(
                          text: "Recolher Dinheiro",
                          imagePath: Paths.Recolher_Dinheiro,
                          disable: true,
                          onTap: () {},
                        ),
                        MenuOptionsWidget(
                          text: "Solicitações",
                          imagePath: Paths.Solicitacoes,
                          disable: true,
                          onTap: () {},
                        ),
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
