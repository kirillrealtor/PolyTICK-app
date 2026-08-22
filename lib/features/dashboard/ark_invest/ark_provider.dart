import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/core/models/ark_models.dart';

const List<String> allEtfSymbols = [
  'ARKA', 'ARKB', 'ARKC', 'ARKD', 'ARKF', 'ARKG',
  'ARKK', 'ARKQ', 'ARKW', 'ARKX', 'ARKVX', 'ARKZ',
  'ARKY', 'CTRU', 'CYBR', 'CYCL', 'FOOD', 'IZRL',
  'LIFE', 'LUSA', 'NFRA', 'PMNT', 'PRNT'
];

const List<String> tradesEnabledSymbols = [
  'ARKK', 'ARKQ', 'ARKW', 'ARKG', 'ARKF', 'ARKX'
];

final arkActiveSectionProvider = StateProvider<String>((ref) => 'etfTrades');

final arkSelectedSymbolsProvider = StateProvider<List<String>>((ref) => List.from(tradesEnabledSymbols));

final arkStockSymbolProvider = StateProvider<String>((ref) => 'TSLA');

final arkDirectionProvider = StateProvider<String>((ref) => '');

final arkLimitProvider = StateProvider<int>((ref) => 499);

final arkDateFromProvider = StateProvider<String>((ref) {
  final past = DateTime.now().subtract(const Duration(days: 30));
  return DateFormat('yyyy-MM-dd').format(past);
});

final arkDateToProvider = StateProvider<String>((ref) {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
});

// ── 1. ETF Trades Provider ──
final arkEtfTradesProvider = FutureProvider<List<ArkTradeItem>>((ref) async {
  final symbols = ref.watch(arkSelectedSymbolsProvider);
  final dateFrom = ref.watch(arkDateFromProvider);
  final dateTo = ref.watch(arkDateToProvider);
  final limit = ref.watch(arkLimitProvider);

  if (symbols.isEmpty) return [];

  final symbolParam = symbols.join(',');
  try {
    final response = await ApiClient.instance.get(
      ApiConfig.arkEtfTrades,
      queryParameters: {
        'symbol': symbolParam,
        'date_from': dateFrom,
        'date_to': dateTo,
        'limit': limit,
      },
    );

    final data = response.data;
    List rawList = [];
    if (data is Map<String, dynamic> && data['trades'] is List) {
      rawList = data['trades'] as List;
    } else if (data is List) {
      rawList = data;
    }

    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => ArkTradeItem.fromJson(e))
        .toList();

    // Sort newest date first
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  } catch (e, stack) {
    debugPrint('Error fetching ARK ETF Trades: $e\n$stack');
    rethrow;
  }
});

// ── 2. ETF Holdings Provider ──
final arkEtfHoldingsProvider = FutureProvider<List<ArkHoldingItem>>((ref) async {
  final symbols = ref.watch(arkSelectedSymbolsProvider);
  final dateFrom = ref.watch(arkDateFromProvider);
  final dateTo = ref.watch(arkDateToProvider);
  final limit = ref.watch(arkLimitProvider);

  if (symbols.isEmpty) return [];

  final symbolParam = symbols.join(',');
  try {
    final response = await ApiClient.instance.get(
      ApiConfig.arkEtfHoldings,
      queryParameters: {
        'symbol': symbolParam,
        'date_from': dateFrom,
        'date_to': dateTo,
        'limit': limit,
      },
    );

    final data = response.data;
    List rawList = [];
    if (data is Map<String, dynamic> && data['holdings'] is List) {
      rawList = data['holdings'] as List;
    } else if (data is List) {
      rawList = data;
    }

    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => ArkHoldingItem.fromJson(e))
        .toList();

    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  } catch (e, stack) {
    debugPrint('Error fetching ARK ETF Holdings: $e\n$stack');
    rethrow;
  }
});

// ── 3. ETF Profile Provider ──
final arkEtfProfilesProvider = FutureProvider<List<ArkProfileItem>>((ref) async {
  final symbols = ref.watch(arkSelectedSymbolsProvider);
  if (symbols.isEmpty) return [];

  final profiles = <ArkProfileItem>[];
  for (final sym in symbols) {
    try {
      final response = await ApiClient.instance.get(
        ApiConfig.arkEtfProfile,
        queryParameters: {'symbol': sym},
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['profile'] is Map) {
        profiles.add(ArkProfileItem.fromJson(Map<String, dynamic>.from(data['profile'] as Map)));
      }
    } catch (e) {
      debugPrint('Error fetching ARK profile for $sym: $e');
    }
  }
  return profiles;
});

// ── 4. ETF News Provider ──
final arkEtfNewsProvider = FutureProvider<List<ArkNewsItem>>((ref) async {
  final symbols = ref.watch(arkSelectedSymbolsProvider);
  final dateFrom = ref.watch(arkDateFromProvider);
  final dateTo = ref.watch(arkDateToProvider);
  final limit = ref.watch(arkLimitProvider);

  if (symbols.isEmpty) return [];

  final symbolParam = symbols.join(',');
  try {
    final response = await ApiClient.instance.get(
      ApiConfig.arkEtfNews,
      queryParameters: {
        'symbol': symbolParam,
        'date_from': dateFrom,
        'date_to': dateTo,
        'limit': limit,
      },
    );

    final data = response.data;
    List rawList = [];
    if (data is Map<String, dynamic> && data['news'] is List) {
      rawList = data['news'] as List;
    } else if (data is List) {
      rawList = data;
    }

    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => ArkNewsItem.fromJson(e))
        .toList();

    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  } catch (e, stack) {
    debugPrint('Error fetching ARK ETF News: $e\n$stack');
    rethrow;
  }
});

// ── 5. Stock Trades Provider ──
final arkStockTradesProvider = FutureProvider<List<ArkTradeItem>>((ref) async {
  final stockSymbol = ref.watch(arkStockSymbolProvider).trim().toUpperCase();
  final dateFrom = ref.watch(arkDateFromProvider);
  final dateTo = ref.watch(arkDateToProvider);
  final limit = ref.watch(arkLimitProvider);
  final direction = ref.watch(arkDirectionProvider);

  if (stockSymbol.isEmpty) return [];

  final params = <String, dynamic>{
    'symbol': stockSymbol,
    'date_from': dateFrom,
    'date_to': dateTo,
    'limit': limit,
  };
  if (direction.isNotEmpty) {
    params['direction'] = direction;
  }

  try {
    final response = await ApiClient.instance.get(
      ApiConfig.arkStockTrades,
      queryParameters: params,
    );

    final data = response.data;
    List rawList = [];
    if (data is Map<String, dynamic> && data['trades'] is List) {
      rawList = data['trades'] as List;
    } else if (data is List) {
      rawList = data;
    }

    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => ArkTradeItem.fromJson(e))
        .toList();

    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  } catch (e, stack) {
    debugPrint('Error fetching ARK Stock Trades for $stockSymbol: $e\n$stack');
    rethrow;
  }
});
