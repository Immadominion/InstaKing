// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:insta_king/core/constants/env_assets.dart';
import 'package:insta_king/core/constants/env_colors.dart';
import 'package:insta_king/core/extensions/widget_extension.dart';
import 'package:insta_king/presentation/views/shared_widgets/cta_button.dart';

class BaseAuthView extends StatefulWidget {
  final String pageName;
  final String pageCTA;
  final String inversePageName;
  final String callToActionText;
  final String callToActionFooterText;
  final String checkBoxText;
  final bool isLogin;
  final bool isLoginWithFingerPrint;
  final bool checked;
  final bool isForgotPassword;
  final Function()? onForgotPassword;
  final void Function(bool?)? onChanged;
  final void Function()? toGoToInversePage;
  final Widget? anyWidget;
  final Widget? anyWidget1;
  final Widget? anyWidget2;
  final Widget? anyWidget3;
  final Widget? anyWidget4;
  final Widget? anyWidget5;
  final Widget? anyWidget6;
  final void Function()? toPerformAuthAction;

  const BaseAuthView({
    Key? key,
    required this.pageName,
    required this.pageCTA,
    required this.inversePageName,
    required this.callToActionText,
    required this.callToActionFooterText,
    required this.checkBoxText,
    required this.isLogin,
    this.isLoginWithFingerPrint = false,
    this.checked = false,
    this.isForgotPassword = false,
    this.onForgotPassword,
    this.onChanged,
    required this.toGoToInversePage,
    this.anyWidget = const SizedBox(),
    this.anyWidget1 = const SizedBox(),
    this.anyWidget2 = const SizedBox(),
    this.anyWidget3 = const SizedBox(),
    this.anyWidget4 = const SizedBox(),
    this.anyWidget5 = const SizedBox(),
    this.anyWidget6 = const SizedBox(),
    this.toPerformAuthAction,
  }) : super(key: key);

  @override
  State<BaseAuthView> createState() => _BaseAuthViewState();
}

class _BaseAuthViewState extends State<BaseAuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: widget.isForgotPassword
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            _buildCheckbox(),
            _buildAdditionalWidgets(),
            _buildFooter(),
          ],
        ).afmNeverScroll,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 40.h),
        widget.isForgotPassword
            ? SizedBox(
                width: double.maxFinite,
                child: Text(
                  widget.pageName,
                  style: TextStyle(
                    fontFamily: 'Montesserat',
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ).afmPadding(
                  EdgeInsets.symmetric(horizontal: 20.w),
                ),
              )
            : Center(
                child: Text(
                  widget.pageName,
                  style: TextStyle(
                    fontFamily: 'Montesserat',
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ).afmPadding(
                  EdgeInsets.symmetric(horizontal: 20.w),
                ),
              ),
        SizedBox(height: widget.isForgotPassword ? 10.h : 20.h),
        widget.isForgotPassword
            ? const Center(
                child: Text(
                  "Can't remember your password? We're here to assist you with your account recovery.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Montesserat',
                  ),
                ),
              ).afmPadding(
                EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: 6.h,
                ),
              )
            : const SizedBox(),
        widget.anyWidget == null
            ? const SizedBox()
            : widget.anyWidget!.afmCenter,
        widget.anyWidget1 == null
            ? const SizedBox()
            : widget.anyWidget1!.afmCenter,
        widget.anyWidget2 == null
            ? const SizedBox()
            : widget.anyWidget2!.afmCenter,
        widget.anyWidget3 == null
            ? const SizedBox()
            : widget.anyWidget3!.afmCenter,
        widget.anyWidget4 == null
            ? const SizedBox()
            : widget.anyWidget4!.afmCenter,
        widget.anyWidget5 == null
            ? const SizedBox()
            : widget.anyWidget5!.afmCenter,
        widget.anyWidget6 == null
            ? const SizedBox()
            : widget.anyWidget6!.afmCenter,
      ],
    );
  }

  Widget _buildCheckbox() {
    return Padding(
      padding: EdgeInsets.only(left: 15.sp, right: 25.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              (widget.isForgotPassword || widget.isLoginWithFingerPrint)
                  ? const SizedBox()
                  : Checkbox(
                      value: widget.checked,
                      onChanged: widget.onChanged,
                      activeColor: InstaColors.mildGrey,
                    ),
              Text(
                widget.checkBoxText,
                softWrap: true,
                maxLines: 3,
                style: TextStyle(
                  fontFamily: 'Montesserat',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          widget.isLogin
              ? GestureDetector(
                  onTap: widget.onForgotPassword,
                  child: Text(
                    widget.callToActionText,
                    style: TextStyle(
                      fontFamily: 'Montesserat',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: InstaColors.primaryColor,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildAdditionalWidgets() {
    return widget.isLoginWithFingerPrint
        ? Image.asset(
            EnvAssets.getImagePath('fingerprint-scan'),
            width: 40.w,
            height: 40.h,
            color: Theme.of(context).unselectedWidgetColor,
            semanticLabel: 'Use Fingerprint To Login',
          ).afmPadding(
            EdgeInsets.only(
              top: 50.h,
            ),
          )
        : const SizedBox();
  }

  Widget _buildFooter() {
    return Column(
      children: [
        SizedBox(
          height: widget.isForgotPassword
              ? (MediaQuery.of(context).size.height / 3)
              : (widget.isLoginWithFingerPrint ? 40.h : 20.h),
        ),
        CustomButton(
          pageCTA: widget.pageCTA,
          buttonOnPressed: widget.toPerformAuthAction,
          agreeTC: widget.isLogin ? false : !widget.checked,
        ).afmCenter,
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: widget.toGoToInversePage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.callToActionFooterText,
                style: TextStyle(
                  fontFamily: 'Montesserat',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.inversePageName,
                style: TextStyle(
                  fontFamily: 'Montesserat',
                  color: InstaColors.primaryColor[700],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ).afmPadding(
            EdgeInsets.only(bottom: 20.h),
          ),
        ),
      ],
    );
  }
}
