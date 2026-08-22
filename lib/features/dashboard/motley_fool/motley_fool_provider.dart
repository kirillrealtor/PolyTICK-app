import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/core/models/motley_fool_item.dart';

final motleyFoolTypeProvider = StateProvider<String>((ref) => 'long'); // 'long' or 'short'

final motleyFoolSearchProvider = StateProvider<String>((ref) => '');

final motleyFoolDataProvider = FutureProvider<List<MotleyFoolItem>>((ref) async {
  final activeType = ref.watch(motleyFoolTypeProvider);

  try {
    final endpoint = activeType == 'short'
        ? ApiConfig.motleyFoolShort
        : ApiConfig.motleyFoolLong;

    final response = await ApiClient.instance.get(
      endpoint,
      queryParameters: {'limit': 10000},
    );

    final data = response.data;
    List rawList = [];

    if (data is Map<String, dynamic> && data['data'] is List) {
      rawList = data['data'] as List;
    } else if (data is List) {
      rawList = data;
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => MotleyFoolItem.fromJson(e))
        .toList();
  } catch (e, stack) {
    debugPrint('Error fetching Motley Fool data: $e\n$stack');
    rethrow;
  }
});
