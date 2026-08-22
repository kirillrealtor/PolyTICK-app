import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';

class CongressStatsModel {
  final String totalTrades;
  final String totalVolume;
  final String membersCount;
  final String tickersCount;

  const CongressStatsModel({
    this.totalTrades = '—',
    this.totalVolume = '—',
    this.membersCount = '—',
    this.tickersCount = '—',
  });

  factory CongressStatsModel.fromJson(Map<String, dynamic> json) {
    // Unpack inner 'analytics' map if present
    final map = (json['analytics'] is Map<String, dynamic>)
        ? json['analytics'] as Map<String, dynamic>
        : json;

    String formatNum(dynamic val, [String fallback = '—']) {
      if (val == null) return fallback;
      if (val is String) {
        if (val.trim().isEmpty) return fallback;
        return val.trim();
      }
      if (val is num) {
        if (val >= 1000000000) {
          return '\$${(val / 1000000000).toStringAsFixed(3)}B';
        } else if (val >= 1000000) {
          return '\$${(val / 1000000).toStringAsFixed(2)}M';
        } else if (val >= 1000) {
          return val.toInt().toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              );
        }
        return val.toString();
      }
      return val.toString();
    }

    return CongressStatsModel(
      totalTrades: formatNum(map['trades'] ?? map['total_trades'] ?? map['trades_count']),
      totalVolume: formatNum(map['volume'] ?? map['total_volume']),
      membersCount: formatNum(map['politicians'] ?? map['members_count'] ?? map['politicians_count']),
      tickersCount: formatNum(map['uniqueTickers'] ?? map['issuers'] ?? map['tickers_count']),
    );
  }
}

final congressStatsProvider = FutureProvider<CongressStatsModel>((ref) async {
  try {
    final response = await ApiClient.instance.get(ApiConfig.congressAnalytics);
    if (response.data is Map<String, dynamic>) {
      return CongressStatsModel.fromJson(response.data as Map<String, dynamic>);
    }
  } catch (e) {
    debugPrint('Congress stats fetch error: $e');
  }
  return const CongressStatsModel();
});
