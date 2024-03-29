import 'package:elephant_control/app/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/popups/logout_popup.dart';
import '../../../widgetsShared/text_button_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../fingerPrintSetting/page/finger_print_setting_page.dart';
import '../../resetPassword/page/reset_password_page.dart';
import '../page/settings_app_page.dart';

class CardProfileTabListWidget extends StatelessWidget {
  final Widget iconCard;
  final String titleIconPath;
  final destinationsPages page;

  const CardProfileTabListWidget(
      { Key? key,
        required this.iconCard,
        required this.titleIconPath,
        required this.page,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: SizedBox(
        height: 10.h,
        width: double.infinity,
        child: Card(
          color: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.h),
          ),
          elevation: 3,
          child: TextButtonWidget(
            onTap: (){
              switch(page){
                case destinationsPages.settings:
                  Get.to(() => SettingsAppPage());
                  break;
                case destinationsPages.fingerPrintSetting:
                  Get.to(() => FingerPrintSettingPage());
                  break;
                case destinationsPages.resetPassword:
                  Get.to(() => ResetPasswordPage());
                  break;
                case destinationsPages.logout:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutPopup();
                    },
                  );
                  break;
              }
            },
            borderRadius: 1.h,
            componentPadding: EdgeInsets.all(.5.w),
            widgetCustom: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5.h,
                        child: Center(
                          child: iconCard,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: TextWidget(
                            titleIconPath,
                            textColor: AppColors.blackColor,
                            fontSize: 16.sp,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.defaultColor,
                        size: 3.h,
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