import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/core/models/leaderboard_model.dart';

final leaderboardPeriodProvider = StateProvider<String>((ref) => '30');

final leaderboardSortKeyProvider = StateProvider<String>((ref) => 'total_trades');

final leaderboardSortDirProvider = StateProvider<String>((ref) => 'desc');

final leaderboardSearchProvider = StateProvider<String>((ref) => '');

final leaderboardDataProvider = FutureProvider<List<LeaderboardItem>>((ref) async {
  try {
    final response = await ApiClient.instance.get(ApiConfig.leaderboard);
    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] is List) {
      final list = (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => LeaderboardItem.fromJson(e))
          .toList();
      return list;
    }
    return [];
  } catch (e, stack) {
    debugPrint('Error fetching leaderboard: $e\n$stack');
    rethrow;
  }
});
