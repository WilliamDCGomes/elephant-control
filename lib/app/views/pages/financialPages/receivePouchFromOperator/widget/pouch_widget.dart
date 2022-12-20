import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_widget.dart';

//ignore: must_be_immutable
class PouchWidget extends StatefulWidget {
  late String title;
  late String operatorName;
  late RxBool checked;

  PouchWidget({
    Key? key,
    required this.title,
    required this.operatorName,
  }) : super(key: key);

  @override
  State<PouchWidget> createState() => _PouchWidgetState();
}

class _PouchWidgetState extends State<PouchWidget> {

  @override
  void initState() {
    widget.checked = false.obs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.checked.value = !widget.checked.value;
      },
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
              Obx(
                () => Container(
                  width: 5.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1.5.h),
                      bottomLeft: Radius.circular(1.5.h),
                    ),
                    color: widget.checked.value ? AppColors.greenColor : AppColors.defaultColor,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(1.h),
                  child: TextWidget(
                    widget.title,
                    textColor: AppColors.blackColor,
                    fontSize: 18.sp,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Obx(
                () => Checkbox(
                  checkColor: AppColors.whiteColor,
                  activeColor: AppColors.defaultColor,
                  value: widget.checked.value,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
