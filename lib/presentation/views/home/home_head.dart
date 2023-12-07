import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_king/core/constants/env_colors.dart';
import 'package:insta_king/core/extensions/widget_extension.dart';

class HomeHeaderWidget extends StatefulWidget {
  final String? username;
  final void Function()? onNotificationsTap;
  final void Function()? onProfileTap;
  const HomeHeaderWidget({
    Key? key,
    required this.username,
    this.onNotificationsTap,
    this.onProfileTap,
  });

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: widget.onProfileTap,
              child: CircleAvatar(
                radius: 25.r,
                child: const Icon(Icons.person_add_alt_sharp),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username == null
                      ? 'Hi, User'
                      : 'Hi, ${widget.username}',
                  style: TextStyle(
                    fontFamily: 'Montesserat',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontFamily: 'Montesserat',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ).afmPadding(EdgeInsets.only(left: 6.h)),
          ],
        ),
        // GestureDetector(
        //   onTap: onNotificationsTap,
        //   child: Image.asset(
        //     EnvAssets.getIconPath('bell'),
        //     width: 30.w,
        //     height: 30.h,
        //     color: EnvColors.darkColor,
        //   ).afmPadding(EdgeInsets.only(right: 6.h)),
        // ),
      ],
    );
  }
}
