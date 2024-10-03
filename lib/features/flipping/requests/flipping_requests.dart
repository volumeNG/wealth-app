import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:wealth/features/flipping/models/FlippingModel.dart';
import 'package:wealth/features/flipping/models/NewFlippingModel.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import '../../../presentation/pages/homepage.dart';
import '../../../storage/secure_storage.dart';
import '../../dio_initialization.dart';
import '../../provider/dio.dart';

SecureStorage _storage = SecureStorage();

Future imagesHostToUrl(List<File?> filePaths) async {
  List<String> filePathUrls = [];
  try {
    for (int i = 0; i < filePaths.length; i++) {
      final mimeTypeData =
          lookupMimeType(filePaths[i]!.path, headerBytes: [0xFF, 0xD8])
              ?.split('/');
      var formData = FormData.fromMap(
        {
          "image": await MultipartFile.fromFile(filePaths[i]!.path,
              contentType: MediaType(mimeTypeData![0], mimeTypeData[1]))
        },
      );
      Response response = await dio.post("/upload/image", data: formData);
      filePathUrls.add(response.data["data"]["url"]);
    }
    return filePathUrls;
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

Future imagesToBeHosted(File? filePaths) async {
  try {
    final mimeTypeData =
        lookupMimeType(filePaths!.path, headerBytes: [0xFF, 0xD8])?.split('/');
    var formData = FormData.fromMap(
      {
        "image": await MultipartFile.fromFile(filePaths.path,
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1]))
      },
    );
    Response response = await dio.post("/upload/image", data: formData);
    return response.data["data"]["url"];
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

Future<dynamic> saveFlipping(String flippingId) async {
  try {
    final data = {
      "flippingId": flippingId,
    };
    // print(crowdFundId);
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/savedFlipping", data: data);
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

Future<dynamic> createProperty(NewProperty newProperty) async {
  try {
    final data = {
      "thumbnail": newProperty.thumbnailUrl,
      "title": newProperty.title,
      "description": newProperty.description,
      "size": newProperty.propertySize,
      "price": newProperty.price,
      "streetLocation": newProperty.streetLocation,
      "videoUrl": newProperty.videoUrl,
      "emergencyEmail": newProperty.emergencyEmail,
      "emergencyContact": newProperty.emergencyContact,
      "images": newProperty.images,
      "location": newProperty.location,
      "type": newProperty.type,
      "rooms": newProperty.rooms ?? 0,
    };
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");

    Response response = await dio.post("/flipping", data: data);
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

final getAllFlippingProperty = FutureProvider.family
    .autoDispose<List<FlippingModel>, int>((ref, int pageNumber) async {
  final apiWatch = ref.watch(dioProvider);
  final List<FlippingModel> flippingProperties = [];
  try {
    final Response response;
    response = await apiWatch.get("/flipping?page=$pageNumber&limit=5");

    final List<dynamic> data = response.data["data"];
    ref.read(totalPageNumber.notifier).state = response.data["meta"]["total"];
    for (int i = 0; i < data.length; i++) {
      flippingProperties.add(FlippingModel.fromJson(data[i]));
    }
    return flippingProperties;
  } catch (e) {
    // Handle error
    // throw Exception("Failed to fetch crowdFund data: $e");
    return Future.error(e);
  }
});

final singleFlippingProperty = FutureProvider.family
    .autoDispose<FlippingModel, String>((ref, String id) async {
  final apiWatch = ref.watch(dioProvider);
  final FlippingModel flippingProperties;
  try {
    final Response response;
    response = await apiWatch.get("/flipping/" + id);
    final dynamic data = response.data["data"];
    flippingProperties = FlippingModel.fromJson(data);
    return flippingProperties;
  } catch (e) {
    // Handle error
    // throw Exception("Failed to fetch crowdFund data: $e");
    return Future.error(e);
  }
});

final personalFlippingProperties = FutureProvider.family
    .autoDispose<List<FlippingModel>, String>((ref, String id) async {
  final apiWatch = ref.watch(dioProvider);
  final List<FlippingModel> flippingProperty = [];
  try {
    final Response response;
    response = await apiWatch.get("/flipping?ownById=$id");
    final List<dynamic> data = response.data["data"];
    for (int i = 0; i < data.length; i++) {
      flippingProperty.add(FlippingModel.fromJson(data[i]));
    }
    return flippingProperty;
  } catch (e) {
    // Handle error
    // throw Exception("Failed to fetch crowdFund data: $e");
    return Future.error(e);
  }
});
