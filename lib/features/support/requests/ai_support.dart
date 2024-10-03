import 'package:dio/dio.dart';

import '../../../storage/secure_storage.dart';
import '../../dio_initialization.dart';


SecureStorage _storage = SecureStorage();

Future<dynamic> sendAiQuestion(String question) async {
  try {
    final data = {
      "message": question,
    };
    dio.options.headers["Authorization"] =
    await _storage.readSecureData("accessToken");
    Response response = await dio.post("/webhook/ai-support", data: data);
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