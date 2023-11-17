import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_king/core/constants/constants.dart';
import 'package:insta_king/core/extensions/widget_extension.dart';
import 'package:insta_king/presentation/controllers/insta_dashboard_controller.dart';
import 'package:insta_king/presentation/controllers/insta_login_controller.dart';
import 'package:insta_king/presentation/views/authentication/login/login.dart';
import 'package:insta_king/presentation/views/profile/account_profile_card.dart';
import 'package:insta_king/presentation/views/profile/profile_view_model.dart';
import 'package:insta_king/presentation/views/profile/sub_profile_views.dart/api_key.dart';
import 'package:insta_king/presentation/views/profile/sub_profile_views.dart/bank_account_details/bank_account_details.dart';
import 'package:insta_king/presentation/views/profile/sub_profile_views.dart/change_password.dart';
import 'package:insta_king/presentation/views/profile/sub_profile_views.dart/more_information.dart';
import 'package:insta_king/presentation/views/profile/sub_profile_views.dart/profile_details/personal_details_view.dart';
import 'package:insta_king/presentation/views/profile/sub_profile_views.dart/refer_and_earn/refer_and_earn.dart';

class InstaProfile extends StatelessWidget {
  const InstaProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnvColors.appBackgroundColor,
      body: Consumer(builder: ((context, ref, child) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Account',
                style: TextStyle(
                  fontFamily: 'Montesserat',
                  fontSize: 20.sp,
                  color: EnvColors.darkColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              ProfileCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PersonalDetails(),
                    ),
                  );
                },
                onProfileIconTap: () {},
              ),
              Container(
                      color: EnvColors.lightColor,
                      child: Column(
                        children: [
                          ProfileViewModel(
                            modelText: 'Bank Account Details',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const BankAccountLink(),
                                ),
                              );
                            },
                          ).afmPadding(),
                          ProfileViewModel(
                            modelText: 'Refer And Earn',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ReferAndEarn(),
                                ),
                              );
                            },
                          ).afmPadding(),
                          ProfileViewModel(
                            modelText: 'More Information',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const MoreInformation(),
                                ),
                              );
                            },
                          ).afmPadding(),
                          ProfileViewModel(
                            modelText: 'Api Key',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ApiKeyPage(),
                                ),
                              );
                            },
                          ).afmPadding(),
                          ProfileViewModel(
                            modelText: 'Change Password',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ChangePassword(),
                                ),
                              );
                            },
                          ).afmPadding(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontFamily: 'Montesserat',
                                  fontSize: 14.sp,
                                  color: EnvColors.darkColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Switch(
                                // thumb color (round icon)
                                activeColor: EnvColors.primaryColor,
                                activeTrackColor: EnvColors.mildLightColor,
                                inactiveThumbColor: EnvColors.mildGrey,
                                inactiveTrackColor: EnvColors.mildLightColor,
                                splashRadius: 50.0,
                                // boolean variable value
                                value: false,
                                // changes the state of the switch
                                onChanged: (value) {},
                              ).afmPadding(EdgeInsets.only(right: 6.h)),
                            ],
                          ).afmPadding(),
                          const ProfileViewModel(modelText: 'Support')
                              .afmPadding(),
                        ],
                      ).afmPadding(EdgeInsets.all(10.sp)))
                  .afmBorderRadius(BorderRadius.circular(10.r)),
              GestureDetector(
                onTap: () {
                  ref.read(instaLoginController.notifier).signOut().then(
                    (value) {
                      ref
                          .read(dashBoardControllerProvider.notifier)
                          .resetPage();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const InstaLogin(),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  color: EnvColors.lightColor,
                  child: const ProfileViewModel(modelText: 'Sign Out')
                      .afmPadding(EdgeInsets.all(18.sp))
                      .afmPadding(EdgeInsets.only(right: 6.sp)),
                )
                    .afmBorderRadius(BorderRadius.circular(10.r))
                    .afmPadding(EdgeInsets.only(top: 20.h)),
              ),
            ],
          ).afmPadding(EdgeInsets.only(left: 20.w, right: 20.w)),
        );
      })),
    );
  }
}
