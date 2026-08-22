import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/core/models/trade_model.dart';

class CongressTradesQuery {
  final int page;
  final int limit;
  final String search;
  final String sizeRange;
  final bool? isOption;
  final bool undervalued;
  final bool underPoliticianPricing;
  final String sort;
  final String direction;

  const CongressTradesQuery({
    this.page = 1,
    this.limit = 10,
    this.search = '',
    this.sizeRange = '',
    this.isOption,
    this.undervalued = false,
    this.underPoliticianPricing = false,
    this.sort = 'filing_date',
    this.direction = 'DESC',
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'skip': (page - 1) * limit,
      'limit': limit,
      'sort': sort,
      'direction': direction,
    };
    if (search.isNotEmpty) params['search'] = search;
    if (sizeRange.isNotEmpty) params['size_range'] = sizeRange;
    if (isOption != null) params['is_option'] = isOption;
    if (undervalued) params['undervalued'] = true;
    if (underPoliticianPricing) params['under_politician_pricing'] = true;
    return params;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CongressTradesQuery &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          limit == other.limit &&
          search == other.search &&
          sizeRange == other.sizeRange &&
          isOption == other.isOption &&
          undervalued == other.undervalued &&
          underPoliticianPricing == other.underPoliticianPricing &&
          sort == other.sort &&
          direction == other.direction;

  @override
  int get hashCode => Object.hash(
        page, limit, search, sizeRange, isOption,
        undervalued, underPoliticianPricing, sort, direction,
      );
}

final congressTradesQueryProvider = StateProvider<CongressTradesQuery>((ref) {
  return const CongressTradesQuery();
});

/// Stores the total count returned by the last API response
final congressTradesTotalProvider = StateProvider<int>((ref) => 0);

final congressTradesProvider = FutureProvider<List<TradeModel>>((ref) async {
  final query = ref.watch(congressTradesQueryProvider);

  try {
    final response = await ApiClient.instance.get(
      ApiConfig.congressTrades,
      queryParameters: query.toQueryParams(),
    );
    final data = response.data;

    int totalCount = 0;
    List rawList = [];

    if (data is Map<String, dynamic>) {
      totalCount = (data['total'] as num?)?.toInt() ?? 0;
      if (data['data'] is List) {
        rawList = data['data'] as List;
      } else if (data['trades'] is List) {
        rawList = data['trades'] as List;
      }
    } else if (data is List) {
      rawList = data;
      totalCount = rawList.length;
    }

    // Store the total count in a separate provider
    Future.microtask(() {
      ref.read(congressTradesTotalProvider.notifier).state = totalCount;
    });

    return rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => TradeModel.fromJson(e))
        .toList();
  } catch (e, stack) {
    debugPrint('Error fetching congress trades: $e\n$stack');
    rethrow;
  }
});
