import 'dart:ui';
import 'package:elephant_control/base/models/roles/role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/button_widget.dart';
import '../../../widgetsShared/text_widget.dart';

class RoleUserPopup extends StatefulWidget {
  final List<Role> roles;

  const RoleUserPopup({
    Key? key,
    required this.roles,
  }) : super(key: key);

  @override
  State<RoleUserPopup> createState() => _RoleUserPopupState();
}

class _RoleUserPopupState extends State<RoleUserPopup> {
  late bool showPopup;

  @override
  void initState() {
    showPopup = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 150));
      setState(() {
        showPopup = true;
      });
    });
  }

  List<Role> get roles => widget.roles;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Visibility(
        visible: showPopup,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.h),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(2.h),
                  color: AppColors.defaultColor,
                  child: TextWidget(
                    "Selecione os acessos do usuário",
                    textColor: AppColors.whiteColor,
                    fontSize: 18.sp,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: roles.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(2.h),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => setState(() => roles[index].checked = !roles[index].checked),
                          child: Container(
                            height: 8.h,
                            margin: EdgeInsets.only(bottom: 2.h),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.5.h),
                              ),
                              elevation: 3,
                              child: Row(
                                children: [
                                  Container(
                                    width: 5.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(1.5.h),
                                        bottomLeft: Radius.circular(1.5.h),
                                      ),
                                      color: roles[index].checked ? AppColors.greenColor : AppColors.defaultColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextWidget(
                                      roles[index].name,
                                      textColor: AppColors.blackColor,
                                      fontSize: 16.sp,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Checkbox(
                                    checkColor: AppColors.whiteColor,
                                    activeColor: AppColors.defaultColor,
                                    value: roles[index].checked,
                                    hoverColor: AppColors.defaultColor,
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => BorderSide(
                                        width: .25.h,
                                        color: AppColors.defaultColor,
                                      ),
                                    ),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2.h, 1.h, 2.h, 0.5.h),
                  child: ButtonWidget(
                    hintText: "SALVAR",
                    fontWeight: FontWeight.bold,
                    widthButton: double.infinity,
                    onPressed: () => Get.back(result: true),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2.h, 0.5.h, 2.h, 2.h),
                  child: ButtonWidget(
                    hintText: "CANCELAR",
                    fontWeight: FontWeight.bold,
                    widthButton: double.infinity,
                    onPressed: () => Get.back(result: false),
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
