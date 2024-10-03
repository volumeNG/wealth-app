import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:wealth/features/chat/models/ChatGroup.dart';
import 'package:wealth/features/chat/models/MessageBox.dart';

import '../../../presentation/pages/homepage.dart';
import '../../../storage/secure_storage.dart';
import '../../crowd_funding/requests/crowd_funding.dart';
import '../../dio_initialization.dart';
import '../../provider/dio.dart';

SecureStorage _storage = SecureStorage();

final getChatLists =
    FutureProvider.family<List<ChatGroup>, String>((ref, String type) async {
  final apiWatch = ref.watch(dioProvider);
  final List<ChatGroup> chats = [];
  try {
    final Response response;
    response = await apiWatch.get("/chatGroup?type=" + type);
    final data = response.data["data"];
    for (int i = 0; i < data.length; i++) {
      chats.add(ChatGroup.fromJson(data[i]));
    }
    return chats;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});

final getChats = FutureProvider.family
    .autoDispose<List<MessageBox>, Tuple2<String, int>>(
        (ref, chatIdPage) async {
  final apiWatch = ref.watch(dioProvider);
  final List<MessageBox> messages = [];
  try {
    final Response response;
    response = await apiWatch.get(
        "/message?chatGroupId=${chatIdPage.item1}&page=${chatIdPage.item2}&limit=15");

    ref.read(totalPageNumber.notifier).state = response.data["meta"]["total"];
    final List<dynamic> data = response.data["data"];
    for (int i = 0; i < data.length; i++) {
      messages.add(MessageBox.fromJson(data[i]));
    }
    return messages;
  } catch (e) {
    // Handle error
    // throw Exception("Failed to fetch crowdFund data: $e");
    return Future.error(e);
  }
});

Future<dynamic> sendMessage(
    String groupId, String text, String? replyId) async {
  try {
    final data = {"chatGroupId": groupId, "text": text, "replyId": replyId};
    dio.options.headers["authorization"] =
        await _storage.readSecureData("accessToken");
    Response response = await dio.post("/message", data: data);
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
