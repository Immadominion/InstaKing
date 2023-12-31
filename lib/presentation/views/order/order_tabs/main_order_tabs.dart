import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_king/core/constants/env_colors.dart';
import 'package:insta_king/core/extensions/widget_extension.dart';

class OrderChips extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final void Function(bool)? onSelected;
  final String label;
  const OrderChips(
      {super.key,
      required this.isSelected,
      this.onSelected,
      required this.label,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: InstaColors.primaryColor,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.r),
      ),
      padding: EdgeInsets.all(5.sp),

      label: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ), //Text
    ).afmPadding(EdgeInsets.only(right: 10.w));
  }
}
