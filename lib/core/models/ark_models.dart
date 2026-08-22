class ArkTradeItem {
  final String date;
  final String fund;
  final String ticker;
  final String company;
  final String direction;
  final int? shares;
  final num? etfPercent;
  final String? cusip;

  const ArkTradeItem({
    required this.date,
    required this.fund,
    required this.ticker,
    required this.company,
    required this.direction,
    this.shares,
    this.etfPercent,
    this.cusip,
  });

  factory ArkTradeItem.fromJson(Map<String, dynamic> json) {
    return ArkTradeItem(
      date: json['date']?.toString() ?? '',
      fund: json['fund']?.toString() ?? '',
      ticker: json['ticker']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      direction: json['direction']?.toString() ?? 'Buy',
      shares: (json['shares'] as num?)?.toInt(),
      etfPercent: json['etf_percent'] as num?,
      cusip: json['cusip']?.toString(),
    );
  }
}

class ArkHoldingItem {
  final String date;
  final String fund;
  final String ticker;
  final String company;
  final int? shares;
  final num? marketValue;
  final num? weight;
  final int? weightRank;
  final num? sharePrice;

  const ArkHoldingItem({
    required this.date,
    required this.fund,
    required this.ticker,
    required this.company,
    this.shares,
    this.marketValue,
    this.weight,
    this.weightRank,
    this.sharePrice,
  });

  factory ArkHoldingItem.fromJson(Map<String, dynamic> json) {
    return ArkHoldingItem(
      date: json['date']?.toString() ?? '',
      fund: json['fund']?.toString() ?? '',
      ticker: json['ticker']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      shares: (json['shares'] as num?)?.toInt(),
      marketValue: json['market_value'] as num?,
      weight: json['weight'] as num?,
      weightRank: (json['weight_rank'] as num?)?.toInt(),
      sharePrice: json['share_price'] as num?,
    );
  }
}

class ArkProfileItem {
  final String symbol;
  final String name;
  final String description;
  final String fundType;
  final String inceptionDate;
  final String cusip;
  final String isin;
  final String website;

  const ArkProfileItem({
    required this.symbol,
    required this.name,
    required this.description,
    required this.fundType,
    required this.inceptionDate,
    required this.cusip,
    required this.isin,
    required this.website,
  });

  factory ArkProfileItem.fromJson(Map<String, dynamic> json) {
    return ArkProfileItem(
      symbol: json['symbol']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      fundType: json['fund_type']?.toString() ?? '',
      inceptionDate: json['inception_date']?.toString() ?? '',
      cusip: json['cusip']?.toString() ?? '',
      isin: json['isin']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
    );
  }
}

class ArkNewsItem {
  final String date;
  final String headline;
  final String summary;
  final String url;

  const ArkNewsItem({
    required this.date,
    required this.headline,
    required this.summary,
    required this.url,
  });

  factory ArkNewsItem.fromJson(Map<String, dynamic> json) {
    return ArkNewsItem(
      date: json['date']?.toString() ?? '',
      headline: json['headline']?.toString() ?? json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? json['description']?.toString() ?? '',
      url: json['url']?.toString() ?? json['link']?.toString() ?? '',
    );
  }
}
