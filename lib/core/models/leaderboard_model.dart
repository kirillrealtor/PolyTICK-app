int _toInt(dynamic val, [int fallback = 0]) {
  if (val == null) return fallback;
  if (val is num) return val.toInt();
  if (val is String) return int.tryParse(val) ?? fallback;
  return fallback;
}

num _toNum(dynamic val, [num fallback = 0]) {
  if (val == null) return fallback;
  if (val is num) return val;
  if (val is String) return num.tryParse(val) ?? fallback;
  return fallback;
}

class LeaderboardPeriodStats {
  final int numBuys;
  final int numSells;
  final int numExchanges;
  final int numOptions;
  final int totalTrades;
  final num volBought;
  final num volSold;
  final num volExchanged;
  final num medianBuy;
  final num medianSell;
  final num medianExchange;
  final num totalMedianSum;
  final num buySellRatio;

  const LeaderboardPeriodStats({
    this.numBuys = 0,
    this.numSells = 0,
    this.numExchanges = 0,
    this.numOptions = 0,
    this.totalTrades = 0,
    this.volBought = 0,
    this.volSold = 0,
    this.volExchanged = 0,
    this.medianBuy = 0,
    this.medianSell = 0,
    this.medianExchange = 0,
    this.totalMedianSum = 0,
    this.buySellRatio = 0,
  });

  factory LeaderboardPeriodStats.fromJson(Map<String, dynamic> json) {
    return LeaderboardPeriodStats(
      numBuys: _toInt(json['num_buys']),
      numSells: _toInt(json['num_sells']),
      numExchanges: _toInt(json['num_exchanges']),
      numOptions: _toInt(json['num_options']),
      totalTrades: _toInt(json['total_trades']),
      volBought: _toNum(json['vol_bought']),
      volSold: _toNum(json['vol_sold']),
      volExchanged: _toNum(json['vol_exchanged']),
      medianBuy: _toNum(json['median_buy']),
      medianSell: _toNum(json['median_sell']),
      medianExchange: _toNum(json['median_exchange']),
      totalMedianSum: _toNum(json['total_median_sum']),
      buySellRatio: _toNum(json['buy_sell_ratio']),
    );
  }
}

class LeaderboardItem {
  final String politician;
  final String? profileImageUrl;
  final Map<String, LeaderboardPeriodStats> periods;

  const LeaderboardItem({
    required this.politician,
    this.profileImageUrl,
    required this.periods,
  });

  LeaderboardPeriodStats getPeriodStats(String period) {
    return periods[period] ?? const LeaderboardPeriodStats();
  }

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    final pol = json['politician']?.toString() ?? 'Unknown';
    final img = json['profile_image_url']?.toString();
    final periodsMap = <String, LeaderboardPeriodStats>{};

    const validPeriods = ['14', '30', '45', '60', '90', '180', '365', '1095', 'all'];
    for (final p in validPeriods) {
      if (json[p] is Map<String, dynamic>) {
        periodsMap[p] = LeaderboardPeriodStats.fromJson(json[p] as Map<String, dynamic>);
      } else if (json[p] is Map) {
        periodsMap[p] = LeaderboardPeriodStats.fromJson(Map<String, dynamic>.from(json[p] as Map));
      } else {
        periodsMap[p] = const LeaderboardPeriodStats();
      }
    }

    return LeaderboardItem(
      politician: pol,
      profileImageUrl: img,
      periods: periodsMap,
    );
  }
}
