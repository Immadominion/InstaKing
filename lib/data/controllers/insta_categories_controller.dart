// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insta_king/data/local/secure_storage_service.dart';
import 'package:insta_king/data/services/categories_services.dart';
import 'package:insta_king/data/services/error_service.dart';
import 'package:insta_king/data/controllers/base_controller.dart';
import 'package:insta_king/presentation/model/insta_get_category_model.dart';
import 'package:insta_king/presentation/model/insta_get_one_service_detail_model.dart';
import 'package:insta_king/presentation/model/insta_get_service_details_model.dart';
import 'package:insta_king/presentation/views/services/service_widgets.dart';

final instaCategoriesController = ChangeNotifierProvider<CategoriesController>(
    (ref) => CategoriesController());

class CategoryItem {
  final String id;
  final String name;
  CategoryItem({required this.id, required this.name});
}

class ServiceItem {
  final String id;
  final String name;
  final String min;
  final String max;
  final String price;
  //final String max;

  ServiceItem(
      {required this.min,
      required this.max,
      required this.price,
      required this.id,
      required this.name});
}

class CategoriesController extends BaseChangeNotifier {
  final CategoriesService categoriesService = CategoriesService();
  final GetCategoriesService getCategoriesService = GetCategoriesService();
  final GetAllServiceDetails getAllServiceDetails = GetAllServiceDetails();
  final GetOneServiceDetails getOneServiceDetails = GetOneServiceDetails();
  late GetAllServicesModel getAllServicesModel = GetAllServicesModel();
  late GetCategoriesModel getCategoriesModel = GetCategoriesModel();
  late GetOneServiceDetailsModel getOneServiceDetailsModel =
      GetOneServiceDetailsModel();
  List<CategoryItem> allCategoriesModel = <CategoryItem>[];
  List<ServiceItem> allServicesModel = [];
  List<ServiceItem> servicesModel = []; /*New*/
  late List<dynamic>? filteredData = [];
  late List<dynamic>? servicesData = []; /*New*/
  late List<dynamic>? filteredServiceData = [];
  late String _selectedServiceValue = '9486';
  late String _selectedServiceName;
  late String _selectedServicePrice = '0.0';
  late String _selectedCategoryValue = '703';
  late String _selectedCategoryName;
  String get selectedService => _selectedServiceValue;
  String get selectedServiceName => _selectedServiceName;
  String get selectedServicePrice => _selectedServicePrice;
  String get selectedCategory => _selectedCategoryValue;
  String get selectedCategoryName => _selectedCategoryName;
  bool _isCatSet = false;
  bool _isServiceSet = false;
  bool get isCatSet => _isCatSet;
  bool get isServiceSet => _isServiceSet;
  late bool hasTappedStatus = false;
  late bool getServiceAnyhow = false;

  void disposeCategries() {
    allServicesModel = [];
    getAllServicesModel.data = [];
    getCategoriesModel.data = [];
    getOneServiceDetailsModel.data = Data();
    filteredData = [];
    servicesData = [];
    filteredServiceData = [];
    super.dispose();
  }

  void setCatValue(String newValue, String name) {
    _selectedCategoryValue = newValue;
    _selectedCategoryName = name;
    _isCatSet = true;
    notifyListeners();
  }

  void setServiceValue(String newValue, String name, String price) {
    _selectedServiceValue = newValue;
    _selectedServiceName = name;
    _selectedServicePrice = price;
    _isServiceSet = true;
    notifyListeners();
  }

  String calculatePricePerUnit(String intakePriceStr, String quantityStr) {
    // Convert string inputs to numeric values
    double intakePrice = double.tryParse(intakePriceStr) ?? 0.0;
    int quantity = int.tryParse(quantityStr) ?? 0;

    // Calculate the price per unit
    double pricePerUnit = (intakePrice / 1000) * quantity;
    //notifyListeners();
    // Return the result as a string
    debugPrint('$pricePerUnit');
    debugPrint('This is the price o $intakePriceStr');
    debugPrint(' We have to order this amount $quantityStr');
    return pricePerUnit.toString();
  }

  // Future setServiceValue(String newValu) {
  //   return toGetDropdownItemsById(newValu);
  // }

  final SecureStorageService secureStorageService =
      SecureStorageService(secureStorage: const FlutterSecureStorage());

  Future<bool> toGetAllCategories() async {
    try {
      //loadingState = LoadingState.loading;
      final res = await categoriesService.getAllCategories();
      toGetAllServiceDetail();
      // toGetDropdownItemsById(_selectedCategoryValue);
      //debugPrint('${res.data}');
      if (res.statusCode == 200) {
        final getCategoriesModel =
            GetCategoriesModel.fromJson(res.data as Map<String, dynamic>);
        allCategoriesModel = getCategoriesModel.data?.map((category) {
              return CategoryItem(
                id: category.id.toString(),
                name: category.name ?? "",
              );
            }).toList() ??
            <CategoryItem>[];
        // loadingState = LoadingState.idle;
        debugPrint("INFO: Success converting data to model");
        if (getCategoriesModel.status == 'success') {
          return true;
        }
      } else {
        // throw Error();
      }
    } on DioException catch (e) {
      //loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    } catch (e) {
      // loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    }
    return false;
  }

  Future<List<dynamic>?> searchByName(String keyword) async {
    if (getAllServicesModel.data == null) {
      return null;
    }
    // Filter the data list based on the keyword in the name field
    filteredData = getAllServicesModel.data!
        .where((datum) => datum.name?.toLowerCase().contains(keyword) == true)
        .toList();
    //notifyListeners();
    debugPrint(filteredData.toString());
    return filteredData;
  }

  Future<bool> getSpecificCategories(String categoryId) async {
    //loadingState = LoadingState.loading;
    try {
      final res = await getCategoriesService.getSpecificCategoriesServices(
          categoryId: categoryId);
      if (res.statusCode == 200) {
        //loadingState = LoadingState.idle;
        //notifyListeners();
        return true;
      } else {}
    } on DioException catch (e) {
      // loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    } catch (e) {
      // loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    }
    return false;
  }

  Future<List<ServiceItem>> toGetAllServiceDetail() async {
    // loadingState = LoadingState.loading;
    bool _hasTappedStatus() {
      // notifyListeners();
      return hasInstagramBeenTapped ||
          hasFacebookBeenTapped ||
          hasBoomplayBeenTapped ||
          hasYoutubeBeenTapped ||
          hasSpotifyBeenTapped ||
          hasSnapchatBeenTapped ||
          hasTelegramBeenTapped ||
          hasAudiomackBeenTapped ||
          hasTiktokBeenTapped ||
          hasDeezerBeenTapped;
    }

    hasTappedStatus = _hasTappedStatus();
    debugPrint('Has Any Button Been Tapped? => $hasTappedStatus');
    // debugPrint('This is current data => ${getAllServicesModel.data}');

    if (getAllServicesModel.data == null || getAllServicesModel.data == []) {
      try {
        //loadingState = LoadingState.loading;
        final res = await getAllServiceDetails.getAllServicesDetails();
        //log(res.toString());
        if (res.statusCode == 200) {
          getAllServicesModel = GetAllServicesModel.fromJson(res.data);
          // If filteredData is not null, use it instead of getAllServicesModel.data
          debugPrint('Service has been gotten !!!');
          servicesData =
              hasTappedStatus ? filteredData : getAllServicesModel.data;
          servicesModel = servicesData
                  ?.map((category) => ServiceItem(
                        id: category.id.toString(),
                        name: category.name ?? "",
                        min: category.min ?? "00.00",
                        max: category.max ?? "00.00",
                        price: category.price ?? "00.00",
                      ))
                  .toList() ??
              [];

          //loadingState = LoadingState.idle;
          //notifyListeners();
          return servicesModel;
          // loadingState = LoadingState.idle;
          // notifyListeners();
          // return getAllServicesModel;
        } else {
          // throw Error();
        }
      } on DioException catch (e) {
        //  loadingState = LoadingState.error;
        ErrorService.handleErrors(e);
      } catch (e) {
        //  loadingState = LoadingState.error;
        ErrorService.handleErrors(e);
      }
    } else {
      try {
        servicesData =
            hasTappedStatus ? filteredData : getAllServicesModel.data;
        servicesModel = servicesData
                ?.map((category) => ServiceItem(
                      id: category.id.toString(),
                      name: category.name ?? "",
                      min: category.min ?? "00.00",
                      max: category.max ?? "00.00",
                      price: category.price ?? "00.00",
                    ))
                .toList() ??
            [];
      } catch (e) {
        debugPrint('We have Error => $e');
      }
      return servicesModel;
    }
    return servicesModel;
  }

  Future<List<ServiceItem>> toGetDropdownItemsById(
    String targetId,
  ) async {
    //loadingState = LoadingState.loading;
    if (allServicesModel.isNotEmpty || allServicesModel != []) {
      // Filter the data based on the specified id
      final filteredServiceData = getAllServicesModel.data
          ?.where((category) => category.categoryId == targetId)
          .toList();

      // Determine the selected service value based on the first id obtained
      _selectedServiceValue = filteredServiceData?.isNotEmpty == true
          ? filteredServiceData![0].id.toString()
          : "";

      // Convert the filtered data to List<DropdownMenuItem<String>>
      allServicesModel = filteredServiceData
              ?.map((category) => ServiceItem(
                    id: category.id.toString(),
                    name: category.name ?? "",
                    min: category.min ?? "loading...",
                    max: category.max ?? "loading...",
                    price: category.price ?? "00.00",
                    //   max: category.max ?? "loading...",
                  ))
              .toList() ??
          [];
      //loadingState = LoadingState.idle;
      toGetOneServiceDetail(_selectedServiceValue);
      //notifyListeners();
      return allServicesModel;
    }
    //loadingState = LoadingState.loading;
    try {
      final res = await getAllServiceDetails.getAllServicesDetails();
      if (res.statusCode == 200) {
        getAllServicesModel = GetAllServicesModel.fromJson(res.data);
        // Filter the data based on the specified id
        final filteredServiceData = getAllServicesModel.data
            ?.where((category) => category.categoryId == targetId)
            .toList();

        // Determine the selected service value based on the first id obtained
        _selectedServiceValue = filteredServiceData?.isNotEmpty == true
            ? filteredServiceData![0].id.toString()
            : "";
        // Convert the filtered data to List<DropdownMenuItem<String>>
        allServicesModel = filteredServiceData
                ?.map((category) => ServiceItem(
                      id: category.id.toString(),
                      name: category.name ?? "",
                      min: category.min ?? "00.00",
                      max: category.max ?? "00.00",
                      price: category.price ?? "00.00",
                      // max: category.max ?? "loading...",
                    ))
                .toList() ??
            [];
        return allServicesModel;
      } else {
        // throw Error();
      }
    } on DioException catch (e) {
      // loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    } catch (e) {
      //  loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    }
    return [];
  }

  String? getOneServiceName(String? serviceId) {
    if (serviceId != null || serviceId != '') {
      toGetOneServiceDetail(serviceId!);
    }
    return getOneServiceDetailsModel.data?.name;
  }

  Future<bool> toGetOneServiceDetail(String serviceId) async {
    //loadingState = LoadingState.loading;
    try {
      final res = await getOneServiceDetails.getOneServicesDetails(serviceId);
      if (res.statusCode == 200) {
        getOneServiceDetailsModel =
            GetOneServiceDetailsModel.fromJson(res.data);
        // loadingState = LoadingState.idle;
        // notifyListeners();
        if (getOneServiceDetailsModel.status == 'success') {
          return true;
        }
      } else {
        // throw Error();
      }
    } on DioException catch (e) {
      // loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    } catch (e) {
      // loadingState = LoadingState.error;
      ErrorService.handleErrors(e);
    }
    return false;
  }
}
