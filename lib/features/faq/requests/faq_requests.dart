import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/dio.dart';
import '../models/faq_model.dart';

final getFAQList = FutureProvider.autoDispose<List<FAQ>>((ref) async {
  final apiWatch = ref.watch(dioProvider);
  List<FAQ> faqList = [];
  try {
    final Response response;
    response = await apiWatch.get("/faq");
    final data = await response.data["data"];
    for (int i = 0; i < data.length; i++) {
      faqList.add(FAQ.fromJson(data[i]));
    }

    return faqList;
  } catch (e) {
    // Handle error
    throw Exception("Failed to fetch crowdFund data: $e");
  }
});
