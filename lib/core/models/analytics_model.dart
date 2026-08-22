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

class YearTradeCount {
  final String year;
  final int tradeCount;

  const YearTradeCount({required this.year, required this.tradeCount});

  factory YearTradeCount.fromJson(Map<String, dynamic> json) {
    return YearTradeCount(
      year: json['year']?.toString() ?? '',
      tradeCount: _toInt(json['tradeCount']),
    );
  }
}

class PartyTradeCount {
  final String party;
  final int tradeCount;

  const PartyTradeCount({required this.party, required this.tradeCount});

  factory PartyTradeCount.fromJson(Map<String, dynamic> json) {
    return PartyTradeCount(
      party: json['party']?.toString() ?? 'other',
      tradeCount: _toInt(json['tradeCount']),
    );
  }
}

class AnalyticsData {
  final int trades;
  final int politicians;
  final num avgTradesPerPolitician;
  final int buys;
  final int sells;
  final int exchanges;
  final int options;
  final int uniqueTickers;
  final num totalVolume;
  final num volBought;
  final num volSold;
  final num totalNetFlow;
  final num netVolume;
  final num buySellRatio;
  final num sentimentScore;
  final int spouseTrades;
  final int jointTrades;
  final int selfTrades;
  final List<YearTradeCount> tradesByYear;
  final List<PartyTradeCount> tradesByParty;
  final List<TopTickerAnalytics> topTickers;
  final List<SectorSummaryItem> sectorSummary;
  final List<PartyConvergenceItem> convergence;
  final List<MomentumPoint> momentumSeries;

  const AnalyticsData({
    this.trades = 0,
    this.politicians = 0,
    this.avgTradesPerPolitician = 0,
    this.buys = 0,
    this.sells = 0,
    this.exchanges = 0,
    this.options = 0,
    this.uniqueTickers = 0,
    this.totalVolume = 0,
    this.volBought = 0,
    this.volSold = 0,
    this.totalNetFlow = 0,
    this.netVolume = 0,
    this.buySellRatio = 0,
    this.sentimentScore = 0,
    this.spouseTrades = 0,
    this.jointTrades = 0,
    this.selfTrades = 0,
    this.tradesByYear = const [],
    this.tradesByParty = const [],
    this.topTickers = const [],
    this.sectorSummary = const [],
    this.convergence = const [],
    this.momentumSeries = const [],
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    final yearList = (json['tradesByYear'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => YearTradeCount.fromJson(e))
        .toList();

    final partyList = (json['tradesByParty'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => PartyTradeCount.fromJson(e))
        .toList();

    final tickersList = (json['topTickers'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => TopTickerAnalytics.fromJson(e))
        .toList();

    final sectorsList = (json['sectorSummary'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => SectorSummaryItem.fromJson(e))
        .toList();

    final convergenceRaw = json['convergence'] ?? json['partyConvergence'] ?? [];
    final convergenceList = (convergenceRaw as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => PartyConvergenceItem.fromJson(e))
        .toList();

    final momentumList = (json['momentumSeries'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => MomentumPoint.fromJson(e))
        .toList();

    final volBought = _toNum(json['volBought']);
    final volSold = _toNum(json['volSold']);
    final totalVol = _toNum(json['totalVolume'], volBought + volSold);
    final netVol = _toNum(json['totalNetFlow'] ?? json['netVolume'], volBought - volSold);
    final totalNet = _toNum(json['totalNetFlow'], netVol);

    return AnalyticsData(
      trades: _toInt(json['trades']),
      politicians: _toInt(json['politicians']),
      avgTradesPerPolitician: _toNum(json['avgTradesPerPolitician']),
      buys: _toInt(json['buys']),
      sells: _toInt(json['sells']),
      exchanges: _toInt(json['exchanges']),
      options: _toInt(json['options']),
      uniqueTickers: _toInt(json['uniqueTickers'], tickersList.length),
      totalVolume: totalVol,
      volBought: volBought,
      volSold: volSold,
      totalNetFlow: totalNet,
      netVolume: netVol,
      buySellRatio: _toNum(json['buySellRatio']),
      sentimentScore: _toNum(json['sentimentScore']),
      spouseTrades: _toInt(json['spouseTrades'] ?? json['spouse_trades']),
      jointTrades: _toInt(json['jointTrades'] ?? json['joint_trades']),
      selfTrades: _toInt(json['selfTrades'] ?? json['self_trades']),
      tradesByYear: yearList,
      tradesByParty: partyList,
      topTickers: tickersList,
      sectorSummary: sectorsList,
      convergence: convergenceList,
      momentumSeries: momentumList,
    );
  }
}

class TopTickerAnalytics {
  final String ticker;
  final int tradeCount;
  final int uniquePoliticians;
  final int numBuys;
  final int numSells;
  final num buyVolume;
  final num sellVolume;
  final num netVolume;

  const TopTickerAnalytics({
    required this.ticker,
    required this.tradeCount,
    required this.uniquePoliticians,
    required this.numBuys,
    required this.numSells,
    required this.buyVolume,
    required this.sellVolume,
    required this.netVolume,
  });

  factory TopTickerAnalytics.fromJson(Map<String, dynamic> json) {
    final buyVol = _toNum(json['buyVolume']);
    final sellVol = _toNum(json['sellVolume']);
    final netVol = _toNum(json['netVolume'], buyVol - sellVol);

    return TopTickerAnalytics(
      ticker: json['ticker']?.toString() ?? '',
      tradeCount: _toInt(json['tradeCount']),
      uniquePoliticians: _toInt(json['uniquePoliticians']),
      numBuys: _toInt(json['numBuys']),
      numSells: _toInt(json['numSells']),
      buyVolume: buyVol,
      sellVolume: sellVol,
      netVolume: netVol,
    );
  }
}

class SectorSummaryItem {
  final String industry;
  final num netFlow;
  final num totalVol;
  final int buys;
  final int sells;
  final num avgRoi;

  const SectorSummaryItem({
    required this.industry,
    required this.netFlow,
    required this.totalVol,
    required this.buys,
    required this.sells,
    required this.avgRoi,
  });

  factory SectorSummaryItem.fromJson(Map<String, dynamic> json) {
    return SectorSummaryItem(
      industry: json['industry']?.toString() ?? 'Other',
      netFlow: _toNum(json['netFlow']),
      totalVol: _toNum(json['totalVol']),
      buys: _toInt(json['buys']),
      sells: _toInt(json['sells']),
      avgRoi: _toNum(json['avgRoi']),
    );
  }
}

class PartyConvergenceItem {
  final String ticker;
  final num demVol;
  final num repVol;
  final num totalVol;

  const PartyConvergenceItem({
    required this.ticker,
    required this.demVol,
    required this.repVol,
    required this.totalVol,
  });

  factory PartyConvergenceItem.fromJson(Map<String, dynamic> json) {
    return PartyConvergenceItem(
      ticker: json['ticker']?.toString() ?? '',
      demVol: _toNum(json['demVol']),
      repVol: _toNum(json['repVol']),
      totalVol: _toNum(json['totalVol']),
    );
  }
}

class MomentumPoint {
  final String date;
  final int month;
  final int year;
  final num buyVol;
  final num sellVol;
  final int buys;
  final int sells;

  const MomentumPoint({
    required this.date,
    required this.month,
    required this.year,
    required this.buyVol,
    required this.sellVol,
    required this.buys,
    required this.sells,
  });

  factory MomentumPoint.fromJson(Map<String, dynamic> json) {
    return MomentumPoint(
      date: json['date']?.toString() ?? '',
      month: _toInt(json['month'], 1),
      year: _toInt(json['year'], 2024),
      buyVol: _toNum(json['buyVol']),
      sellVol: _toNum(json['sellVol']),
      buys: _toInt(json['buys']),
      sells: _toInt(json['sells']),
    );
  }
}
