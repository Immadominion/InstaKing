import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insta_king/core/constants/enum.dart';
import 'package:insta_king/core/constants/env_strings.dart';
import 'package:insta_king/data/local/secure_storage_service.dart';
import 'package:insta_king/data/local/toast_service.dart';
import 'package:insta_king/data/services/error_service.dart';
import 'package:insta_king/data/services/signup_service.dart';
import 'package:insta_king/data/controllers/base_controller.dart';
import 'package:insta_king/presentation/model/insta_signup_model.dart';
import 'package:insta_king/utils/locator.dart';

final instaSignUpController =
    ChangeNotifierProvider<SignUpController>((ref) => SignUpController());

class SignUpController extends BaseChangeNotifier {
  InstaSignUpModel data = InstaSignUpModel();
  late bool checkedBox = false;
  bool get isBoxChecked => checkedBox;

  void toCheckBox(value) {
    checkedBox = !checkedBox;
    debugPrint(checkedBox.toString());
    notifyListeners();
  }

  final signUpService = SignUpService();
  final SecureStorageService secureStorageService =
      SecureStorageService(secureStorage: const FlutterSecureStorage());

  Future<bool> signUp(
    String firstName,
    lastName,
    email,
    userName,
    passWord,
    phone,
    referralCode,
  ) async {
    loadingState = LoadingState.loading;
    try {
      final res = await signUpService.signUp(
        email: email,
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        phone: phone,
        password: passWord,
        referralID: referralCode,
      );
      debugPrint('${res.data}');
      if (res.statusCode == 200 && res.data['status'] == 'success') {
        data = InstaSignUpModel.fromJson(res.data);
        await locator<SecureStorageService>().write(
          key: InstaStrings.token,
          value: data.token ?? '',
        );

        locator<ToastService>().showSuccessToast(
          'You are signed in',
        );
        loadingState = LoadingState.idle;
        return true;
      } else {
        loadingState = LoadingState.idle;
        throw Error();
      }
    } on DioException catch (e) {
      loadingState = LoadingState.idle;
      ErrorService.handleErrors(e);
    } catch (e) {
      loadingState = LoadingState.idle;
      ErrorService.handleErrors(e);
    }
    return false;
  }
}
