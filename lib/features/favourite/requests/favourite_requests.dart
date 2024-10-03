import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth/features/favourite/models/crowdfund_favorite.dart';
import 'package:wealth/features/favourite/models/current_location_favorite.dart';

import '../../../storage/secure_storage.dart';
import '../../flipping/models/FavouriteFlippingModel.dart';
import '../../provider/dio.dart';

SecureStorage _storage = SecureStorage();

final getCrowdFundFavourites =
    FutureProvider.autoDispose<List<CrowdfundFavourite>>((ref) async {
  final apiWatch = ref.watch(dioProvider);
  List<CrowdfundFavourite> crowdFav = [];
  try {
    final Response response;
    apiWatch.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    response = await apiWatch.get("/savedCrowdFund");
    final data = await response.data["data"];
    for (int i = 0; i < data.length; i++) {
      crowdFav.add(CrowdfundFavourite.fromJson(data[i]));
    }
    return crowdFav;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

final getCurrentLocationFavorites =
    FutureProvider.autoDispose<List<CurrentFavourite>>((ref) async {
  final apiWatch = ref.watch(dioProvider);
  List<CurrentFavourite> currentFav = [];
  try {
    final Response response;
    apiWatch.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    response = await apiWatch.get("/savedProperty");
    final data = await response.data["data"];
    for (int i = 0; i < data.length; i++) {
      currentFav.add(CurrentFavourite.fromJson(data[i]));
    }
    return currentFav;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

final getFlippingFund =
    FutureProvider.autoDispose<List<FavouriteFlippingModel>>((ref) async {
  final apiWatch = ref.watch(dioProvider);
  List<FavouriteFlippingModel> flippingFav = [];
  try {
    final Response response;
    apiWatch.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    response = await apiWatch.get("/savedFlipping");
    final data = await response.data["data"];
    for (int i = 0; i < data.length; i++) {
      flippingFav.add(FavouriteFlippingModel.fromJson(data[i]["flipping"]));
    }
    return flippingFav;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});
