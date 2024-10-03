import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:wealth/features/crowd_funding/models/Property.dart';
import 'package:wealth/features/current_locations/models/location.dart';
import 'package:wealth/features/current_locations/models/property_state.dart';

import '../../../presentation/pages/homepage.dart';
import '../../../storage/secure_storage.dart';
import '../../dio_initialization.dart';
import '../../provider/dio.dart';

SecureStorage _storage = SecureStorage();

final getLocations = FutureProvider.family
    .autoDispose<List<CurrentLocationModel>, int>((ref, int pageNumber) async {
  final apiWatch = ref.watch(dioProvider);
  final List<CurrentLocationModel> locations = [];
  try {
    final Response response;
    response = await apiWatch.get("/location?page=$pageNumber&limit=5");
    ref.read(totalPageNumber.notifier).state = response.data["meta"]["total"];
    final List<dynamic> data = response.data["data"];
    for (int i = 0; i < data.length; i++) {
      locations.add(CurrentLocationModel.fromJson(data[i]));
    }
    return locations;
  } catch (e) {
    // Handle error
    // throw Exception("Failed to fetch crowdFund data: $e");
    return Future.error(e);
  }
});

final specificLocationProperties = FutureProvider.family
    .autoDispose<List<Property>, Tuple2<String, int>>((ref, locationId) async {
  final apiWatch = ref.watch(dioProvider);
  final List<Property> locations = [];
  try {
    final Response response;
    response = await apiWatch.get(
        "/property?locationId=${locationId.item1}&page=${locationId.item2}&limit=10");
    ref.read(totalPageNumber.notifier).state = response.data["meta"]["total"];
    final List<dynamic> data = response.data["data"];
    for (int i = 0; i < data.length; i++) {
      locations.add(Property.fromJson(data[i]));
    }
    return locations;
  } catch (e) {
    // Handle error
    // throw Exception("Failed to fetch crowdFund data: $e");
    return Future.error(e);
  }
});

final singleCurrentProperty =
    FutureProvider.family<Property, String>((ref, String id) async {
  final apiWatch = ref.watch(dioProvider);
  final Property property;
  try {
    final Response response;
    response = await apiWatch.get("/property/" + id);
    final data = response.data["data"];
    property = Property.fromJson(data);
    return property;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

Future<dynamic> saveCurrentLocationProperty(String propertyId) async {
  try {
    final data = {
      "propertyId": propertyId,
    };
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/savedProperty", data: data);
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

final getPropertyState =
    FutureProvider.family<List<PropertyData>, String>((ref, String id) async {
  final apiWatch = ref.watch(dioProvider);
  final List<PropertyData> propertyState = [];
  try {
    final Response response;
    response = await apiWatch.get("/propertyState?propertyId=" + id);
    final data = response.data["data"];
    // propertyState = Property.fromJson(data);
    for (int i = 0; i < data.length; i++) {
      propertyState.add(PropertyData.fromJson(data[i]));
    }
    return propertyState;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});
