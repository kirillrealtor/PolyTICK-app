/// Trade model — for congress trades, pelosi trades, politician trades.
class TradeModel {
  final String? id;
  final String politicianName;
  final String? politicianSlug;
  final String? party;
  final String? chamber; // 'House' or 'Senate'
  final String? state;
  final String? ticker;
  final String? assetDescription;
  final String? transactionType; // 'Purchase', 'Sale', etc.
  final String? transactionDate;
  final String? disclosureDate;
  final String? amountRange;
  final String? optionType; // 'Call', 'Put'
  final String? optionStrike;
  final String? optionExpiry;
  final String? photoUrl;
  final String? owner; // 'Self', 'Spouse', 'Joint', 'Child'
  final String? comments;
  final String? sourceUrl;
  final num? estimatedAmountUpper;
  final num? price;
  final num? currentMarketPrice;
  final num? analystLow;
  final num? analystTargetMean;
  final num? analystHigh;

  const TradeModel({
    this.id,
    required this.politicianName,
    this.politicianSlug,
    this.party,
    this.chamber,
    this.state,
    this.ticker,
    this.assetDescription,
    this.transactionType,
    this.transactionDate,
    this.disclosureDate,
    this.amountRange,
    this.optionType,
    this.optionStrike,
    this.optionExpiry,
    this.photoUrl,
    this.owner,
    this.comments,
    this.sourceUrl,
    this.estimatedAmountUpper,
    this.price,
    this.currentMarketPrice,
    this.analystLow,
    this.analystTargetMean,
    this.analystHigh,
  });

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      id: json['id']?.toString() ?? json['original_id']?.toString(),
      politicianName: json['filer_name'] as String? ??
          json['politician_name'] as String? ??
          json['name'] as String? ??
          'Member of Congress',
      politicianSlug: json['politician_slug'] as String? ?? json['slug'] as String?,
      party: json['party'] as String?,
      chamber: json['chamber'] as String?,
      state: json['state_district'] as String? ?? json['state'] as String?,
      ticker: (json['ticker'] != null && json['ticker'] != 'N/A' && json['ticker'] != '--')
          ? json['ticker'] as String?
          : null,
      assetDescription: json['asset_name'] as String? ??
          json['traded_issuer_name'] as String? ??
          json['asset_description'] as String? ??
          json['security_name'] as String?,
      transactionType: json['transaction_type'] as String? ??
          json['type'] as String? ??
          'Purchase',
      transactionDate: json['transaction_date'] as String? ??
          json['trade_date'] as String? ??
          json['traded'] as String?,
      disclosureDate: json['filing_date'] as String? ??
          json['disclosure_date'] as String? ??
          json['notification_date'] as String?,
      amountRange: json['amount_range'] as String? ??
          json['size'] as String? ??
          json['amount'] as String?,
      optionType: json['option_type'] as String?,
      optionStrike: json['option_strike']?.toString(),
      optionExpiry: json['option_expiry'] as String?,
      photoUrl: json['photo_url'] as String? ?? json['image_url'] as String?,
      owner: json['owner'] as String? ?? json['ownership'] as String?,
      comments: json['description'] as String? ??
          json['comments'] as String? ??
          json['comment'] as String? ??
          json['notes'] as String?,
      sourceUrl: json['pdf_url'] as String? ?? json['source_url'] as String? ?? json['ptr_link'] as String? ?? json['filing_url'] as String?,
      estimatedAmountUpper: json['estimated_amount_upper'] as num?,
      price: json['price'] as num?,
      currentMarketPrice: (json['current_market_price'] ?? json['analyst_current_price']) as num?,
      analystLow: json['analyst_low'] as num?,
      analystTargetMean: (json['analyst_avg'] ?? json['analyst_average'] ?? json['analyst_target_mean']) as num?,
      analystHigh: json['analyst_high'] as num?,
    );
  }

  bool get isOption => optionType != null && optionType!.isNotEmpty;
}
