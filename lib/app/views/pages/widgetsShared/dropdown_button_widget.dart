import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../stylePages/app_colors.dart';
import 'text_widget.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String? itemSelected;
  final String? hintText;
  final double? height;
  final double? width;
  final bool? justRead;
  final Iterable<DropdownItem> listItems;
  final Function(String?)? onChanged;
  final int? maxLines;

  const DropdownButtonWidget({
    Key? key,
    required this.listItems,
    this.hintText,
    this.height,
    this.width,
    this.justRead,
    this.itemSelected,
    required this.onChanged,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: justRead ?? false,
      child: Container(
        height: height ?? 65,
        width: width ?? 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.defaultColor,
            width: .25.h,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(1.h),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              elevation: 8,
              dropdownColor: AppColors.whiteColor,
              value: itemSelected,
              onChanged: onChanged,
              hint: TextWidget(
                hintText ?? "",
                fontSize: 16.sp,
                textColor: AppColors.defaultColor,
              ),
              icon: RotationTransition(
                turns: AlwaysStoppedAnimation(3 / 4),
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: AppColors.defaultColor,
                  size: 2.5.h,
                ),
              ),
              items: //(listItems as List<DropdownMenuItem<String>>).toList(),
                  (listItems).map((e) {
                return DropdownMenuItem<String>(
                  value: e.value,
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    // width: (width ?? 200) - 6.h,
                    child: TextWidget(
                      e.item,
                      fontSize: 16.sp,
                      textAlign: TextAlign.start,
                      textColor: AppColors.defaultColor,
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: maxLines ?? 1,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownItem {
  final String item;
  final String? value;

  DropdownItem({required this.item, required this.value});
}
