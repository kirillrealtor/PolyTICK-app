import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/core/models/overlay_models.dart';

final overlayTimeRangeProvider = StateProvider<int?>((ref) => 45); // Default 45 days

final overlayShowMotleyFoolProvider = StateProvider<bool>((ref) => true);

final overlaySortByProvider = StateProvider<String>((ref) => 'mostRecentDate');

final overlaySortDirProvider = StateProvider<String>((ref) => 'desc');

final overlaySearchProvider = StateProvider<String>((ref) => '');

final _arkDio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 20),
  headers: {
    'Accept': 'application/json',
    'User-Agent': 'PolyTICK/1.0',
  },
));

final overlayDataProvider = FutureProvider<List<OverlayItem>>((ref) async {
  final timeRange = ref.watch(overlayTimeRangeProvider);
  final days = timeRange ?? 1825; // 5 years for All Time
  final daysAgo = DateTime.now().subtract(Duration(days: days));
  final dateFromStr = '${daysAgo.year}-${daysAgo.month.toString().padLeft(2, '0')}-${daysAgo.day.toString().padLeft(2, '0')}';

  const etfs = ['ARKK', 'ARKW', 'ARKQ', 'ARKG', 'ARKF', 'ARKX'];

  try {
    // 1. Fetch Congress Trades (Same as Next.js ConfluenceContent)
    final polFuture = ApiClient.instance.get(
      ApiConfig.congressTrades,
      queryParameters: {
        'limit': 50000,
        'exclude_na': true,
        'pub_start_date': dateFromStr,
      },
      options: Options(
        receiveTimeout: const Duration(seconds: 90),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // 2. Fetch ARK Trades in parallel directly from arkfunds.io (Same as Next.js ConfluenceContent)
    final arkFutures = etfs.map((etf) async {
      try {
        final res = await _arkDio.get(
          'https://arkfunds.io/api/v2/etf/trades?symbol=$etf&date_from=$dateFromStr',
        );
        final data = res.data;
        if (data is Map<String, dynamic> && data['trades'] is List) {
          return (data['trades'] as List).map((t) => {...(t as Map), 'etf': etf}).toList();
        } else if (data is List) {
          return data.map((t) => {...(t as Map), 'etf': etf}).toList();
        }
        return <Map<String, dynamic>>[];
      } catch (e) {
        // Fallback to backend proxy if direct ARK fails
        try {
          final res = await ApiClient.instance.get(
            ApiConfig.arkEtfTrades,
            queryParameters: {
              'symbol': etf,
              'date_from': dateFromStr,
              'date_to': DateTime.now().toIso8601String().split('T')[0],
              'limit': 499,
            },
          );
          final data = res.data;
          if (data is Map<String, dynamic> && data['trades'] is List) {
            return (data['trades'] as List).map((t) => {...(t as Map), 'etf': etf}).toList();
          } else if (data is List) {
            return data.map((t) => {...(t as Map), 'etf': etf}).toList();
          }
        } catch (_) {}
        return <Map<String, dynamic>>[];
      }
    });

    // 3. Fetch Motley Fool Long & Short Trades in parallel (Same as Next.js ConfluenceContent)
    final motleyLongFuture = ApiClient.instance.get(
      ApiConfig.motleyFoolLong,
      queryParameters: {'limit': 1000},
    ).catchError((_) => Response(requestOptions: RequestOptions(path: ''), data: {'data': []}));

    final motleyShortFuture = ApiClient.instance.get(
      ApiConfig.motleyFoolShort,
      queryParameters: {'limit': 1000},
    ).catchError((_) => Response(requestOptions: RequestOptions(path: ''), data: {'data': []}));

    // Await all parallel requests
    final results = await Future.wait([
      polFuture,
      Future.wait(arkFutures),
      motleyLongFuture,
      motleyShortFuture,
    ]);

    final polRes = results[0] as Response;
    final arkResults = results[1] as List<List<dynamic>>;
    final motleyLongRes = results[2] as Response;
    final motleyShortRes = results[3] as Response;

    // Process Motley Fool Map (1-to-1 match with Next.js)
    final motleyMap = <String, OverlayMotleyData>{};
    void extractMotley(dynamic data, String dir) {
      if (data is Map && data['data'] is List) {
        for (final item in (data['data'] as List)) {
          if (item is Map && item['ticker'] != null) {
            final tickerStr = item['ticker'].toString();
            final symbols = tickerStr
                .split(RegExp(r'[\s,;]+'))
                .map((s) => s.split(':')[0].trim().toUpperCase())
                .where((s) => s.isNotEmpty);
            for (final t in symbols) {
              motleyMap[t] = OverlayMotleyData(
                dir: dir,
                heldBy: item['held_by_fools'],
                rank: item['rank'],
              );
            }
          }
        }
      }
    }
    extractMotley(motleyLongRes.data, 'Long');
    extractMotley(motleyShortRes.data, 'Short');

    // Process Politicians Map (1-to-1 match with Next.js)
    final polMap = <String, Map<String, dynamic>>{};
    final polData = polRes.data is Map && polRes.data['data'] is List
        ? (polRes.data['data'] as List)
        : (polRes.data is List ? polRes.data as List : []);

    for (final trade in polData) {
      if (trade is! Map) continue;
      final rawTicker = trade['traded_issuer_ticker']?.toString();
      if (rawTicker == null || rawTicker.isEmpty) continue;
      final ticker = rawTicker.split(':')[0].toUpperCase();

      if (!polMap.containsKey(ticker)) {
        polMap[ticker] = {
          'buys': <OverlayPoliticianTrade>[],
          'sells': <OverlayPoliticianTrade>[],
          'companyName': trade['traded_issuer_name']?.toString() ?? '',
        };
      }

      final companyName = trade['traded_issuer_name']?.toString();
      if (companyName != null && (polMap[ticker]!['companyName'] as String).isEmpty) {
        polMap[ticker]!['companyName'] = companyName;
      }

      final type = trade['type']?.toString().toLowerCase() ?? '';
      final isBuy = type.contains('buy') || type.contains('purchase') || type == 'receive' || type == 'exchange';
      final isSell = type.contains('sell') || type.contains('sale');

      final polTrade = OverlayPoliticianTrade(
        name: trade['politician_name']?.toString() ?? 'Politician',
        date: trade['traded']?.toString() ?? '',
        size: trade['size']?.toString() ?? 'N/A',
        polTicker: rawTicker,
        image: trade['profile_image_url']?.toString(),
        isBuy: isBuy,
      );

      if (isBuy) {
        (polMap[ticker]!['buys'] as List<OverlayPoliticianTrade>).add(polTrade);
      } else if (isSell) {
        (polMap[ticker]!['sells'] as List<OverlayPoliticianTrade>).add(polTrade);
      }
    }

    // Process ARK Trades Map (1-to-1 match with Next.js)
    final arkMap = <String, Map<String, dynamic>>{};
    final flatArkTrades = arkResults.expand((x) => x).toList();

    for (final trade in flatArkTrades) {
      if (trade is! Map) continue;
      final rawTicker = trade['ticker']?.toString();
      if (rawTicker == null || rawTicker.isEmpty) continue;
      final ticker = rawTicker.toUpperCase();

      if (!arkMap.containsKey(ticker)) {
        arkMap[ticker] = {
          'net': 0,
          'details': <OverlayArkTrade>[],
        };
      }

      final direction = trade['direction']?.toString() ?? 'Buy';
      final shares = (trade['shares'] as num?)?.toInt() ?? 0;
      final netChange = direction.toLowerCase() == 'buy' ? shares : -shares;

      arkMap[ticker]!['net'] = (arkMap[ticker]!['net'] as int) + netChange;
      (arkMap[ticker]!['details'] as List<OverlayArkTrade>).add(
        OverlayArkTrade(
          etf: trade['etf']?.toString() ?? 'ARK',
          date: trade['date']?.toString() ?? '',
          direction: direction,
          shares: shares,
        ),
      );
    }

    // Compute Overlaps (1-to-1 match with Next.js)
    final overlapList = <OverlayItem>[];

    for (final ticker in arkMap.keys) {
      final pol = polMap[ticker];
      if (pol != null) {
        final buys = pol['buys'] as List<OverlayPoliticianTrade>;
        final sells = pol['sells'] as List<OverlayPoliticianTrade>;

        if (buys.isNotEmpty || sells.isNotEmpty) {
          final arkNet = arkMap[ticker]!['net'] as int;
          final arkDir = arkNet > 0 ? 'Buy' : (arkNet < 0 ? 'Sell' : 'Neutral');

          final polBuysLen = buys.length;
          final polSellsLen = sells.length;
          final polDir = polBuysLen > polSellsLen ? 'Buy' : (polSellsLen > polBuysLen ? 'Sell' : 'Neutral');

          if (arkDir != 'Neutral') {
            final isAligned = arkDir == polDir;
            final polDetails = [...buys, ...sells];
            final arkDetails = arkMap[ticker]!['details'] as List<OverlayArkTrade>;

            final uniquePolNames = polDetails.map((d) => d.name).toSet();

            DateTime mostRecent = DateTime(2000);
            for (final d in polDetails) {
              final parsed = DateTime.tryParse(d.date);
              if (parsed != null && parsed.isAfter(mostRecent)) {
                mostRecent = parsed;
              }
            }
            for (final d in arkDetails) {
              final parsed = DateTime.tryParse(d.date);
              if (parsed != null && parsed.isAfter(mostRecent)) {
                mostRecent = parsed;
              }
            }

            overlapList.add(
              OverlayItem(
                ticker: ticker,
                companyName: pol['companyName'] as String,
                direction: arkDir,
                arkNet: arkNet,
                polBuys: polBuysLen,
                polSells: polSellsLen,
                uniquePols: uniquePolNames.length,
                isAligned: isAligned,
                polDetails: polDetails,
                arkDetails: arkDetails,
                motleyData: motleyMap[ticker],
                mostRecentDate: mostRecent,
              ),
            );
          }
        }
      }
    }

    overlapList.sort((a, b) => b.mostRecentDate.compareTo(a.mostRecentDate));
    return overlapList;
  } catch (e, stack) {
    debugPrint('Error calculating trade overlays: $e\n$stack');
    rethrow;
  }
});
