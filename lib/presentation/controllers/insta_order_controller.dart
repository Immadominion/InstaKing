import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insta_king/core/constants/enum.dart';
import 'package:insta_king/data/local/secure_storage_service.dart';
import 'package:insta_king/data/services/error_service.dart';
import 'package:insta_king/data/services/order_services.dart';
import 'package:insta_king/presentation/controllers/base_controller.dart';
import 'package:insta_king/presentation/model/get_all_order_model.dart';
import 'package:insta_king/presentation/model/get_order_details_model.dart';
import 'package:insta_king/presentation/model/place_order_model.dart';

final instaOrderController =
    ChangeNotifierProvider<OrderController>((ref) => OrderController());

class OrderController extends BaseChangeNotifier {
  final PlaceOrder placeOrder = PlaceOrder();
  final GetOrders getOrder = GetOrders();
  final GetOrderDetails getOrderDetails = GetOrderDetails();
  late GetAllOrderModel getAllOrderModel = GetAllOrderModel();
  late PlaceOrderModel placeOrderModel = PlaceOrderModel();

  final SecureStorageService secureStorageService =
      SecureStorageService(secureStorage: const FlutterSecureStorage());

  Future<bool> toPlaceOrder(
      String serviceId, String link, String quantity) async {
    loadingState = LoadingState.loading;
    try {
      final res = await placeOrder.placeOrder(serviceId, link, quantity);
      if (res.statusCode == 201) {
        debugPrint("INFO: Bearer ${res.data}");
        placeOrderModel = PlaceOrderModel.fromJson(res.data);
        // if ( rememberMe) {
        //   await locator<SecureStorageService>().write(key: EnvStrings.us, value: value)
        // }

        // locator<ToastService>().showSuccessToast(
        //   'Order Purchased Successfully',
        // );
        //print("INFO: Success converting data to model");
        //if (data.status == 'success') {
        loadingState = LoadingState.idle;
        return true;
        //}
      } else {
        debugPrint('${res.statusMessage}');
        debugPrint('${res.statusCode}');
        debugPrint(res.toString());
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

  List<Datum> getOrdersByStatus(Status status) {
    if (getAllOrderModel.data == null) return [];
    return getAllOrderModel.data!
        .where((order) => order.status == status)
        .toList();
  }

  Future<bool> toGetAllOrders() async {
    loadingState = LoadingState.loading;
    try {
      final res = await getOrder.getAllOrders();
      if (res.statusCode == 200) {
        getAllOrderModel = GetAllOrderModel.fromJson(res.data);
        //debugPrint(getAllOrderModel.data.toString());
        //log('All orders so far ===> ${res.data}');
        // if ( rememberMe) {
        //   await locator<SecureStorageService>().write(key: EnvStrings.us, value: value)
        // }

        // locator<ToastService>().showSuccessToast(
        //   'Order loaded successfully',
        // );
        //print("INFO: Success converting data to model");
        loadingState = LoadingState.idle;
        return true;
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

  Future<bool> toGetOrderDetails(orderId) async {
    loadingState = LoadingState.loading;
    try {
      final res =
          await getOrderDetails.getFilteredOrderDetails(orderId: orderId);
      if (res.statusCode == 200) {
        // print("INFO: Bearer ${res..data}");
        final data = GetOrderDetailsModel.fromJson(res.data);

        // if ( rememberMe) {
        //   await locator<SecureStorageService>().write(key: EnvStrings.us, value: value)
        // }

        loadingState = LoadingState.idle;
        // locator<ToastService>().showSuccessToast(
        //   'Categories loaded successfully',
        // );
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
}
