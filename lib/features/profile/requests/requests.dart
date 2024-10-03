import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth/features/profile/model/profile.dart';
import 'package:wealth/features/provider/dio.dart';
import 'package:wealth/storage/secure_storage.dart';

import '../../../presentation/pages/personal_information.dart';
import '../../authentication/models/SignUp.dart';
import '../../dio_initialization.dart';

SecureStorage _storage = SecureStorage();

Future<UserSignUp?> fetchProfile() async {}

final profileProvider = FutureProvider<Profile>((ref) async {
  final apiWatch = ref.watch(dioProvider);
  final Response response;
  final Profile profile;
  try {
    apiWatch.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    response = await apiWatch.get("/profile");
    profile = Profile.fromJson(response.data["data"]);
    return profile;
  } catch (e) {
    return Future.error("error");
  }
});

Future<dynamic> submitProfileUpdate(String id, String name, EUserGender gender,
    String location, String dateOfBirth) async {
  String genderValue;
  switch (gender) {
    case EUserGender.male:
      genderValue = "male";
      break;

    case EUserGender.female:
      genderValue = "female";
      break;

    default:
      genderValue = "male";
  }
  try {
    final data = {
      "name": name,
      // "email": email,
      "gender": genderValue,
      "location": location,
      "dateOfBirth": dateOfBirth,
    };
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.patch("/users/$id", data: data);
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

Future<dynamic> submitProfileImageUpdate(String id, String imgUrl) async {
  try {
    final data = {
      "profileImg": imgUrl,
    };
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.patch("/users/$id", data: data);
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
    return null;
  }
}

Future<dynamic> updateDeviceToken(String deviceToken, String id) async {
  try {
    final data = {
      "deviceNotificationToken ": deviceToken,
    };
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.patch("/users/$id", data: data);
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

// Future<dynamic> sendForgotEmail(String email) async {
//   try {
//     Response response = await dio.post("/auth/send-forgot-email/$email");
//     return response.data;
//   } catch (e) {
//     if (e is DioException) {
//       Response? errorResponse = e.response;
//       if (errorResponse != null) {
//         // Do something with the error response
//         return errorResponse.data;
//       }
//     }
//   }
// }
