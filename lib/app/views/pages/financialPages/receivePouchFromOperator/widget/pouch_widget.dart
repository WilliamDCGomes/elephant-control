import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../../../base/models/visit/model/visit.dart';
import '../../../../stylePages/app_colors.dart';
import '../../../widgetsShared/text_widget.dart';

class PouchWidget extends StatefulWidget {
  final Visit moneyPouch;

  const PouchWidget({Key? key, required this.moneyPouch}) : super(key: key);

  @override
  State<PouchWidget> createState() => _PouchWidgetState();
}

class _PouchWidgetState extends State<PouchWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => widget.moneyPouch.checked = !widget.moneyPouch.checked),
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
                  color: widget.moneyPouch.checked ? AppColors.greenColor : AppColors.defaultColor,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(1.h),
                  child: TextWidget(
                    widget.moneyPouch.machine!.name,
                    textColor: AppColors.blackColor,
                    fontSize: 18.sp,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Checkbox(
                checkColor: AppColors.whiteColor,
                activeColor: AppColors.defaultColor,
                value: widget.moneyPouch.checked,
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
  }
}
