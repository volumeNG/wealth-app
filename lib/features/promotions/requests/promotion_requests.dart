import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth/features/promotions/models/PromotionModel.dart';

import '../../../presentation/pages/homepage.dart';
import '../../../storage/secure_storage.dart';
import '../../dio_initialization.dart';
import '../../provider/dio.dart';

SecureStorage _storage = SecureStorage();

final getAllPromotions =
    // FutureProvider.family.autoDispose<List<PromotionModel>, int>((ref, int pageNumber) async {
    FutureProvider.autoDispose<List<PromotionModel>>((ref) async {
  final apiWatch = ref.watch(dioProvider);
  List<PromotionModel> promotions = [];
  try {
    final Response response;
    // apiWatch.options.headers["authorization"] =
    //     await _storage.readSecureData("accessToken");
    response = await apiWatch.get("/promotion");
    final data = await response.data["data"];
    // ref.read(totalPageNumber.notifier).state = response.data["meta"]["total"];
    for (int i = 0; i < data.length; i++) {
      promotions.add(PromotionModel.fromJson(data[i]));
    }
    return promotions;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

final fetchSinglePromotion = FutureProvider.family
    .autoDispose<PromotionModel, String>((ref, String id) async {
  final apiWatch = ref.watch(dioProvider);
  PromotionModel promotion;
  try {
    final Response response;
    // apiWatch.options.headers["authorization"] =
    //     await _storage.readSecureData("accessToken");
    response = await apiWatch.get("/promotion/$id");
    final data = await response.data["data"];
    promotion = PromotionModel.fromJson(data);
    return promotion;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

Future<dynamic> addInterestInPromotion(String promotionId) async {
  try {
    final data = {
      "promotionId": promotionId,
    };
    dio.options.headers["Authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/promotion/add-interest", data: data);
    return response.data;
  } catch (e) {
    if (e is DioException) {
      // If the error is a DioError, extract the response
      Response? errorResponse = e.response;
      if (errorResponse != null) {
        // Do something with the error response
        return errorResponse.data;
      }
    }
    // For any other type of error, print the error message
    print("Error: $e");
    // Return null if there's no response to return
    return null;
  }
}

Future<dynamic> removeInterestInPromotion(String promotionId) async {
  try {
    final data = {
      "promotionId": promotionId,
    };
    dio.options.headers["Authorization"] =
        await _storage.readSecureData("accessToken");
    Response response =
        await dio.post("/promotion/remove-interest", data: data);
    return response.data;
  } catch (e) {
    if (e is DioException) {
      // If the error is a DioError, extract the response
      Response? errorResponse = e.response;
      if (errorResponse != null) {
        // Do something with the error response
        return errorResponse.data;
      }
    }
    // For any other type of error, print the error message
    print("Error: $e");
    // Return null if there's no response to return
    return null;
  }
}
