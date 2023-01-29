import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/user/user.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/rich_text_two_different_widget.dart';
import '../../../widgetsShared/text_widget.dart';
import '../../trackOperator/page/track_operator_page.dart';

class UserInformationPopup {
  static List<Widget> getWidgetList(
      context,
      final User user,
      final Function editUser,
      ){
    return [
      Center(
        child: Container(
          height: .5.h,
          width: 40.w,
          color: AppColors.grayBackgroundPictureColor,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Container(
          height: 5.h,
          decoration: BoxDecoration(
            color: AppColors.defaultColor,
            borderRadius: BorderRadius.circular(1.h),
          ),
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
          child: Center(
            child: TextWidget(
              user.name,
              textColor: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              textDecoration: TextDecoration.none,
              maxLines: 1,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: RichTextTwoDifferentWidget(
          firstText: "Tipo do Usuário: ",
          firstTextColor: AppColors.blackColor,
          firstTextFontWeight: FontWeight.normal,
          firstTextSize: 16.sp,
          secondText: user.typeName,
          secondTextColor: AppColors.blackColor,
          secondTextFontWeight: FontWeight.bold,
          secondTextSize: 16.sp,
          secondTextDecoration: TextDecoration.none,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: RichTextTwoDifferentWidget(
          firstText: "Cpf: ",
          firstTextColor: AppColors.blackColor,
          firstTextFontWeight: FontWeight.normal,
          firstTextSize: 16.sp,
          secondText: user.document ?? "Não informado",
          secondTextColor: AppColors.blackColor,
          secondTextFontWeight: FontWeight.bold,
          secondTextSize: 16.sp,
          secondTextDecoration: TextDecoration.none,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: ButtonWidget(
          hintText: "EDITAR",
          fontWeight: FontWeight.bold,
          widthButton: 75.w,
          onPressed: () async {
            Get.back();
            await editUser(user);
          },
        ),
      ),
      Visibility(
        visible: user.type == UserType.operator,
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: ButtonWidget(
            hintText: "LOCALIZAR",
            fontWeight: FontWeight.bold,
            widthButton: 75.w,
            onPressed: () {
              Get.back();
              Get.to(() => TrackOperatorPage(
                operator: user,
              ));
            },
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: ButtonWidget(
          hintText: "FECHAR",
          fontWeight: FontWeight.bold,
          widthButton: 75.w,
          onPressed: () => Get.back(),
        ),
      ),
    ];
  }
}