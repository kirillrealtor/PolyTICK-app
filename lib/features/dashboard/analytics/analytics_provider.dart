import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/core/models/analytics_model.dart';

final analyticsDaysProvider = StateProvider<int?>((ref) => 90);

final analyticsSortByProvider = StateProvider<String>((ref) => 'tradeCount');

final analyticsSearchTickerProvider = StateProvider<String>((ref) => '');

final analyticsDataProvider = FutureProvider<AnalyticsData>((ref) async {
  final days = ref.watch(analyticsDaysProvider);
  final sortBy = ref.watch(analyticsSortByProvider);

  final params = <String, dynamic>{
    'sort_by': sortBy,
  };
  if (days != null) {
    params['days'] = days;
  }

  try {
    final response = await ApiClient.instance.get(
      ApiConfig.analytics,
      queryParameters: params,
    );

    final data = response.data;
    if (data is Map<String, dynamic> && data['analytics'] is Map) {
      return AnalyticsData.fromJson(Map<String, dynamic>.from(data['analytics'] as Map));
    }
    throw Exception('Invalid analytics data format');
  } catch (e, stack) {
    debugPrint('Error fetching analytics: $e\n$stack');
    rethrow;
  }
});
