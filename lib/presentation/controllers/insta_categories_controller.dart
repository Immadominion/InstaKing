import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insta_king/core/constants/enum.dart';
import 'package:insta_king/data/local/secure_storage_service.dart';
import 'package:insta_king/data/local/toast_service.dart';
import 'package:insta_king/data/services/categories_services.dart';
import 'package:insta_king/data/services/error_service.dart';
import 'package:insta_king/presentation/controllers/base_controller.dart';
import 'package:insta_king/presentation/model/insta_get_category_model.dart';
import 'package:insta_king/presentation/model/insta_get_one_service_detail_model.dart';
import 'package:insta_king/utils/locator.dart';

final instaCategoriesController = ChangeNotifierProvider<CategoriesController>(
    (ref) => CategoriesController());

class CategoriesController extends BaseChangeNotifier {
  final CategoriesService categoriesService = CategoriesService();
  final GetCategoriesService getCategoriesService = GetCategoriesService();
  final GetAllServiceDetails getAllServiceDetails = GetAllServiceDetails();
  final GetOneServiceDetails getOneServiceDetails = GetOneServiceDetails();

  final SecureStorageService secureStorageService =
      SecureStorageService(secureStorage: const FlutterSecureStorage());

  Future<bool> getAllCategories() async {
    loadingState = LoadingState.loading;
    try {
      final res = await categoriesService.getCategories();
      if (res.statusCode == 200) {
        // print("INFO: Bearer ${res..data}");
        final data = GetCategoriesModel.fromJson(res.data);

        // if ( rememberMe) {
        //   await locator<SecureStorageService>().write(key: EnvStrings.us, value: value)
        // }

        loadingState = LoadingState.idle;
        locator<ToastService>().showSuccessToast(
          'Categories loaded successfully',
        );
        //print("INFO: Success converting data to model");
        if (data.status == 'success') {
          return true;
        }
      } else {
        throw Error();
      }
    } on DioException catch (e) {
      loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    } catch (e) {
      loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    }
    return false;
  }

  Future<bool> getSpecificCategories(String categoryId) async {
    loadingState = LoadingState.loading;
    try {
      final res = await getCategoriesService.getCategoriesServices(
          categoryId: categoryId);
      if (res.statusCode == 200) {
        //final data = GetspecificCategoriesModel.fromJson(res.data);
        loadingState = LoadingState.idle;
        print(res.data);
        //if (data.status == 'success') {
        return true;
        //
        // }
      } else {
        throw Error();
      }
    } on DioException catch (e) {
      loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    } catch (e) {
      loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    }
    return false;
  }

  Future<bool> toGetAllServiceDetail() async {
    loadingState = LoadingState.loading;
    try {
      final res = await getAllServiceDetails.getAllServicesDetails();
      if (res.statusCode == 200) {
        final data = GetCategoriesModel.fromJson(res.data);
        loadingState = LoadingState.idle;
        if (data.status == 'success') {
          return true;
        }
      } else {
        throw Error();
      }
    } on DioException catch (e) {
      loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    } catch (e) {
      loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    }
    return false;
  }

  Future<bool> toGetOneServiceDetail(String serviceId) async {
    loadingState = LoadingState.loading;
    try {
      final res = await getOneServiceDetails.getOneServicesDetails(serviceId);
      if (res.statusCode == 200) {
        final data = GetOneServiceDetailsModel.fromJson(res.data);
        loadingState = LoadingState.idle;
        if (data.status == 'success') {
          return true;
        }
      } else {
        throw Error();
      }
    } on DioException catch (e) {
      loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    } catch (e) {
      loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    }
    return false;
  }
}
