import 'package:dio/dio.dart';
import 'package:wealth/storage/secure_storage.dart';

import '../../dio_initialization.dart';

SecureStorage _storage = SecureStorage();

Future<dynamic> signIn(String email, String password) async {
  try {
    final data = {
      "email": email,
      "password": password,
    };
    Response response = await dio.post("/auth/signin", data: data);
    return response.data;
  } catch (e) {
    if (e is DioException) {
      // If the error is a DioError, extract the response
      Response? errorResponse = e.response;
      if (errorResponse != null) {
        return errorResponse.data;
      }
    }
    // For any other type of error, print the error message
    print("Error: $e");
    // Return null if there's no response to return
    return null;
  }
}

Future<dynamic> signUp({
  required String name,
  required String email,
  required String password,
  required String phoneNumber,
}) async {
  try {
    final data = {
      "name": name,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
    };
    Response response = await dio.post("/auth/signup", data: data);
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

Future<dynamic> verifyToken({
  required int token,
}) async {
  try {
    final data = {
      "token": token,
    };
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response =
        await dio.post("/auth/verify-signup-token/", data: data);
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

Future<dynamic> resendEmail(String email) async {
  try {
    Response response = await dio.post("/auth/resend-signup-email/$email");
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

Future<dynamic> sendForgotEmail(String email) async {
  try {
    Response response = await dio.post("/auth/send-forgot-email/$email");
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

// {
// "statusCode": 200,
// "success": true,
// "message": "Opt send successfully",
// "data": {
// "otp": 6859
// }
// }

Future<dynamic> verifyForgotToken(String email, int token) async {
  try {
    final data = {
      "token": token,
      "email": email,
    };
    Response response = await dio.post("/auth/verify-forgot-token", data: data);
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

Future<dynamic> changePassword(String email, String password, int token) async {
  try {
    final data = {
      "email": email,
      "token": token,
      "password": password,
    };
    Response response = await dio.post("/auth/change-password", data: data);
    return response.data;
  } catch (e) {
    if (e is DioException) {
      // If the error is a DioError, extract the response
      Response? errorResponse = e.response;
      if (errorResponse != null) {
        return errorResponse.data;
      }
    }
    // For any other type of error, print the error message
    print("Error: $e");
    // Return null if there's no response to return
    return null;
  }
}
//
// Future<dynamic> subscribeToApplication(String email, String password, int token) async {
//   try {
//     final data = {
//       "email": email,
//       "token": token,
//       "password": password,
//     };
//     Response response = await dio.post("/users/generate-user-pay-url", data: data);
//     return response.data;
//   } catch (e) {
//     if (e is DioException) {
//       // If the error is a DioError, extract the response
//       Response? errorResponse = e.response;
//       if (errorResponse != null) {
//         return errorResponse.data;
//       }
//     }
//     // For any other type of error, print the error message
//     print("Error: $e");
//     // Return null if there's no response to return
//     return null;
//   }
// }
//
//
// final subscribe =
// FutureProvider.family<List<PropertyData>, String>((ref, String id) async {
//   final apiWatch = ref.watch(dioProvider);
//   final List<PropertyData> propertyState = [];
//   print(id);
//   try {
//     final Response response;
//     response = await apiWatch.get("/users/generate-user-pay-url");
//     final data = response.data["data"];
//     // propertyState = Property.fromJson(data);
//     for (int i = 0; i < data.length; i++) {
//       propertyState.add(PropertyData.fromJson(data[i]));
//     }
//     return propertyState;
//   } catch (e) {
//     // Handle error
//     throw Exception("Failed to fetch crowdFund data: $e");
//   }
// });
