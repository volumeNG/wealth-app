import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth/features/crowd_funding/models/RecentlyFunded.dart';
import 'package:wealth/features/provider/dio.dart';
import 'package:wealth/presentation/pages/homepage.dart';
import 'package:wealth/storage/secure_storage.dart';

import '../../authentication/models/SignUp.dart';
import '../../dio_initialization.dart';
import '../models/Property.dart';
import 'package:tuple/tuple.dart';

SecureStorage _storage = SecureStorage();

Future<UserSignUp?> fetchProfile() async {}

class CrowdFundFilter {
  String? type;
  String? title;
  int? minPrice;
  int? maxPrice;

  CrowdFundFilter(
      {this.type, this.title = "", this.minPrice = 0, this.maxPrice = 0});

  CrowdFundFilter.empty();
}

final crowdFundList =
    FutureProvider.family<List<Property>, Tuple2<CrowdFundFilter?, int>>(
        (ref, filterPageNumber) async {
  final apiWatch = ref.watch(dioProvider);
  try {
    final filter = filterPageNumber.item1;
    final page = filterPageNumber.item2;
    final Response response;
    bool initial = filter != null &&
        filter.type == null &&
        filter.title!.isEmpty &&
        filter.maxPrice! <= 0 &&
        filter.minPrice! <= 0;
    bool titleSearchOnly = filter != null &&
        filter.type == null &&
        filter.title!.isNotEmpty &&
        filter.maxPrice! <= 0 &&
        filter.minPrice! <= 0;
    bool typeSearch = filter != null &&
        filter.type != null &&
        filter.title!.isEmpty &&
        filter.maxPrice! <= 0 &&
        filter.minPrice! <= 0;
    bool minMaxTypeSearch = filter != null &&
        filter.maxPrice! > 0 &&
        filter.minPrice! >= 0 &&
        filter.title!.isEmpty &&
        filter.type != null;
    bool minMaxSearch = filter != null &&
        filter.title!.isEmpty &&
        filter.type == null &&
        filter.maxPrice! > 0 &&
        filter.minPrice! >= 0;
    bool allTypeSearch = filter != null &&
        filter.maxPrice! > 0 &&
        filter.minPrice! >= 0 &&
        filter.type != null &&
        filter.title!.isNotEmpty;
    var url = "/crowdFund?limit=5&page=$page";
    if (typeSearch) {
      response = await apiWatch.get("$url&type=${filter.type}");
    } else if (minMaxTypeSearch) {
      response = await apiWatch.get(
          "$url&maxPrice=${filter.maxPrice}&minPrice=${filter.minPrice}&type=${filter.type}");
    } else if (minMaxSearch) {
      response = await apiWatch
          .get("$url&maxPrice=${filter.maxPrice}&minPrice=${filter.minPrice}");
    } else if (titleSearchOnly) {
      response = await apiWatch.get("$url&searchTerm=${filter.title}");
    } else if (allTypeSearch) {
      response = await apiWatch.get(
          "$url&maxPrice=${filter.maxPrice}&minPrice=${filter.minPrice}&type=${filter.type}&searchTerm=${filter.title}");
    } else {
      response = await apiWatch.get("$url");
    }

    final List<Property> properties = [];
    ref.read(totalPageNumber.notifier).state = response.data["meta"]["total"];
    final List<dynamic> data = response.data["data"];

    for (int i = 0; i < data.length; i++) {
      properties.add(Property.fromJson(data[i]));
    }
    return properties;
  } catch (e) {
    if (e is DioException) {
      Response? errorResponse = e.response;
      if (errorResponse != null) {
// Do something with the error response
        return errorResponse.data;
      }
    }
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

final getRecentlyFunded = FutureProvider<List<RecentlyFunded>>((ref) async {
  final apiWatch = ref.watch(dioProvider);
  List<RecentlyFunded> property = [];
  try {
    final Response response;
    response = await apiWatch.get("/crowdFund?limit=5&page=1&status=sold");
    final data = response.data["data"];
    for (int i = 0; i < data.length; i++) {
      // properties.add(Property.fromJson(data[i]));
      property.add(RecentlyFunded.fromJson(data[i]));
    }
    return property;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

final singleProperty =
    FutureProvider.autoDispose.family<Property, String>((ref, id) async {
  final apiWatch = ref.watch(dioProvider);
  final Property property;
  try {
    final response = await apiWatch.get("/crowdFund/$id");
    final data = response.data["data"];
    property = Property.fromJson(data);
    return property;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

Future<dynamic> saveProperty(String crowdFundId) async {
  try {
    final data = {
      "crowdFundId": crowdFundId,
    };
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/savedCrowdFund", data: data);
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
