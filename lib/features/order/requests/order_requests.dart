import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth/features/order/model/BankModel.dart';
import 'package:wealth/features/order/model/ordered_model.dart';

import '../../../storage/secure_storage.dart';
import '../../dio_initialization.dart';
import '../../provider/dio.dart';
import '../model/UsdRate.dart';

SecureStorage _storage = SecureStorage();

final getBanks = FutureProvider.family
    .autoDispose<List<BankModel>, String>((ref, String bankType) async {
  final apiWatch = ref.watch(dioProvider);
  List<BankModel> banks = [];
  try {
    final Response response;
    response = await apiWatch.get("/bank?typeOfBank=$bankType");
    final data = response.data["data"];
    for (int i = 0; i < data.length; i++) {
      // properties.add(Property.fromJson(data[i]));
      banks.add(BankModel.fromJson(data[i]));
    }
    return banks;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

final getUsdRate = FutureProvider.autoDispose<UsdRate>((ref) async {
  final apiWatch = ref.watch(dioProvider);
  UsdRate rate;
  try {
    final Response response;
    response = await apiWatch.get("/webhook/dollar-rate");
    final rate =UsdRate.fromJson( response.data);
    return rate;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch usd data: $e");
  }
});

Future<dynamic> makeCurrentLocationPayment(
    {required String propertyId,
    required String bankName,
    required String contactNumber,
    required String accountNumber,
    required String wealthBankId,
    String? paymentRecieptUrl}) async {
  try {
    final data = {
      "propertyId": propertyId,
      "refName": "property",
      "bankName": bankName,
      "paymentType": "manual",
      "bankAccountNumber": accountNumber,
      "wealthBankId": wealthBankId,
      // "paymentReceiptUrl"
    };
    // print(crowdFundId);
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/orders", data: data);
    return response.data;
  } catch (e) {
    if (e is DioException) {
      Response? errorResponse = e.response;
      if (errorResponse != null) {
        // Do something with the error response
        return errorResponse.data;
      }
    }
  }
}

Future<dynamic> makeManualCrowdFundOrder(
    {required String propertyId,
    required String bankName,
    required String contactNumber,
    required String accountNumber,
    required String wealthBankId,
      double? amount,
    String? paymentRecieptUrl}) async {
  try {
    final data = {
      "crowdFundId": propertyId,
      "refName": "crowdFund",
      "bankName": bankName,
      "paymentType": "manual",
      "bankAccountNumber": accountNumber,
      "wealthBankId": wealthBankId,
      "amount": amount,
      // "paymentReceiptUrl"
    };
    // print(crowdFundId);
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/orders", data: data);
    return response.data;
  } catch (e) {
    if (e is DioException) {
      Response? errorResponse = e.response;
      if (errorResponse != null) {
        // Do something with the error response
        return errorResponse.data;
      }
    }
  }
}

Future<dynamic> makeManualFlippingOrder(
    {required String propertyId,
    required String bankName,
    required String contactNumber,
    required String accountNumber,
    required String wealthBankId,
    String? paymentRecieptUrl}) async {
  try {
    final data = {
      "flippingId": propertyId,
      "refName": "flipping",
      "bankName": bankName,
      "paymentType": "manual",
      "bankAccountNumber": accountNumber,
      "wealthBankId": wealthBankId,
      // "paymentReceiptUrl"
    };
    // print(crowdFundId);
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/orders", data: data);
    return response.data;
  } catch (e) {
    if (e is DioException) {
      Response? errorResponse = e.response;
      if (errorResponse != null) {
        // Do something with the error response
        return errorResponse.data;
      }
    }
  }
}

Future<dynamic> crowdFundPayment(
    {required String crowdFundId, required double amount}) async {
  try {
    final data = {
      "crowdFundId": crowdFundId,
      "refName": "crowdFund",
      "amount": int.parse(amount.toStringAsFixed(0)),
      "paymentType": "paystack",
    };
    // print(crowdFundId);
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/orders", data: data);
    return response.data;
  } catch (e) {
    if (e is DioException) {
      Response? errorResponse = e.response;
      if (errorResponse != null) {
        // Do something with the error response
        return errorResponse.data;
      }
    }
  }
}

final userOrders = FutureProvider.family
    .autoDispose<List<OrderedModel>, String>((ref, String id) async {
  final apiWatch = ref.watch(dioProvider);
  List<OrderedModel> properties = [];
  try {
    apiWatch.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    final Response response;
    response = await apiWatch.get("/orders?orderById=$id&status=success");
    final data = response.data["data"];
    for (int i = 0; i < data.length; i++) {
      // properties.add(Property.fromJson(data[i]));
      properties.add(OrderedModel.fromJson(data[i]));
    }
    return properties;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});
