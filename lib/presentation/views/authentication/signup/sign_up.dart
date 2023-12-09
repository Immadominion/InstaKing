import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insta_king/core/utils/my_strings.dart';
import 'package:insta_king/presentation/controllers/insta_profile_controller.dart';
import 'package:insta_king/presentation/controllers/insta_signin_controller.dart';
import 'package:insta_king/presentation/views/authentication/auth_shared/base_auth_view.dart';
import 'package:insta_king/presentation/views/authentication/auth_shared/text_form.dart';
import 'package:insta_king/presentation/views/authentication/login/login.dart';
import 'package:insta_king/presentation/views/dashboard/insta_dashboard.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return BaseAuthView(
          pageName: "Create Account",
          callToActionFooterText: "Do you have an account?",
          inversePageName: " Sign in",
          callToActionText: '',
          checkBoxText: "I agree to the terms and policy",
          pageCTA: "Create Account",
          isLogin: false,
          checked: ref.watch(instaSignUpController.notifier).isBoxChecked,
          onChanged: (value) {
            setState(() {
              ref.watch(instaSignUpController.notifier).toCheckBox(value);
              print(value.toString());
            });
          },
          anyWidget: AuthTextField(
            icon: Icons.person_2_outlined,
            hintT: 'Email Address',
            hasSuffix: false,
            controller: emailController,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return MyStrings.enterYourEmail;
              } else if (!MyStrings.emailValidatorRegExp
                  .hasMatch(value ?? '')) {
                return MyStrings.invalidEmailMsg;
              } else {
                return null;
              }
            },
          ),
          anyWidget1: AuthTextField(
            icon: Icons.person_2_outlined,
            hintT: 'First Name',
            hasSuffix: false,
            controller: firstNameController,
          ),
          anyWidget2: AuthTextField(
            icon: Icons.person_2_outlined,
            hintT: 'Last Name',
            hasSuffix: false,
            controller: lastNameController,
          ),
          anyWidget3: AuthTextField(
            icon: Icons.person_2_outlined,
            hintT: 'Username',
            hasSuffix: false,
            controller: userNameController,
          ),
          anyWidget4: AuthTextField(
            icon: Icons.phone_outlined,
            hintT: 'Phone Numbers',
            hasSuffix: false,
            controller: phoneNumberController,
          ),
          anyWidget5: AuthTextField(
            icon: Icons.lock_outline_rounded,
            hintT: 'Password',
            hasSuffix: true,
            isPassword: true,
            controller: passwordController,
            // validator: (value) {
            //   RegExp oneUppercase = RegExp(r'^(?=.*?[A-Z])');
            //   RegExp oneDigit = RegExp(r'^(?=.*?[0-9])');
            //   RegExp oneSpecialChar = RegExp(r'^(?=.*?[!@#\$&*~])');
            //   RegExp atLeastEight = RegExp(r'^.{8,}');
            //   if (value!.isEmpty) {
            //     return MyStrings.enterYourPassword_;
            //   } else {
            //     if (!oneUppercase.hasMatch(value)) {
            //       return MyStrings.upperCaseMsg;
            //     } else if (!oneSpecialChar.hasMatch(value)) {
            //       return MyStrings.oneSpecialCharMsg;
            //     } else if (!oneDigit.hasMatch(value)) {
            //       return MyStrings.oneDigitMsg;
            //     } else if (!atLeastEight.hasMatch(value)) {
            //       return MyStrings.lessThanEightMsg;
            //     } else {
            //       return null;
            //     }
            //   }
            // },
          ),
          anyWidget6: AuthTextField(
            icon: Icons.person_2_outlined,
            hintT: 'Referral ID',
            hasSuffix: false,
            controller: referralController,
          ),
          toGoToInversePage: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const InstaLogin(),
            ));
          },
          toSignOrLogin: () {
            debugPrint(
              'INFO: To Create an account with email:${emailController.text} and password: ${passwordController.text}',
            );
            ref
                .read(instaSignUpController.notifier)
                .signUp(
                  firstNameController.text,
                  lastNameController.text,
                  emailController.text,
                  userNameController.text,
                  passwordController.text,
                  phoneNumberController.text,
                  referralController.text,
                )
                .then(
              (value) {
                if (value) {
                  ref.read(instaProfileController.notifier).getProfileDetails();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const InstaDashboard(),
                  ));
                }
              },
            );
          },
        );
      },
    );
  }
}
