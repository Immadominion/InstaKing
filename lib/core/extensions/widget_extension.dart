import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_king/core/constants/constants.dart';

extension WidgetExtension on Widget {
  Widget get aftmDefaultBorderRadius => ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: this,
      );

  Widget get afmDoubleUp => Transform.scale(
        scale: 2,
        child: this,
      );

  Widget get afmCenter => Center(
        child: this,
      );

  Widget afmBorderRadius(BorderRadius radius) => ClipRRect(
        borderRadius: radius,
        child: this,
      );

  Widget get afmNeverScroll => SingleChildScrollView(
        child: this,
      );

  Widget afmTouchable(
    VoidCallback onTap, {
    Color? splashColor,
    double? elevation,
  }) =>
      Material(
        color: Colors.transparent,
        elevation: elevation ?? 0,
        child: InkWell(
          splashColor: splashColor,
          onTap: onTap,
          child: this,
        ),
      );

  Widget afmPadding([EdgeInsetsGeometry? padding]) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
      child: this,
    );
  }

  Widget get afmWrapUp => Container(
        padding: EdgeInsets.all(3.sp),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: EnvColors.primaryColor,
        ),
        child: this,
      );
}
