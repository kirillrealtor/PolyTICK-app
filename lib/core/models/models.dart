class BlogPostModel {
  final String id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String? publishedAt;
  final String? author;
  final String? coverImage;

  const BlogPostModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    this.publishedAt,
    this.author,
    this.coverImage,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      summary: json['summary'] as String? ?? json['excerpt'] as String? ?? '',
      content: json['content'] as String? ?? '',
      publishedAt: json['published_at'] as String? ?? json['date'] as String?,
      author: json['author'] as String?,
      coverImage: json['cover_image'] as String? ?? json['image'] as String?,
    );
  }
}

class NewsItemModel {
  final String id;
  final String title;
  final String summary;
  final String url;
  final String source;
  final String publishedAt;

  const NewsItemModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.url,
    required this.source,
    required this.publishedAt,
  });

  factory NewsItemModel.fromJson(Map<String, dynamic> json) {
    return NewsItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      url: json['url'] as String? ?? '',
      source: json['source'] as String? ?? '',
      publishedAt: json['published_at'] as String? ?? json['date'] as String? ?? '',
    );
  }
}

class ArkTradeModel {
  final String date;
  final String fund;
  final String ticker;
  final String companyName;
  final String action; // Buy / Sell
  final num shares;

  const ArkTradeModel({
    required this.date,
    required this.fund,
    required this.ticker,
    required this.companyName,
    required this.action,
    required this.shares,
  });

  factory ArkTradeModel.fromJson(Map<String, dynamic> json) {
    return ArkTradeModel(
      date: json['date'] as String? ?? '',
      fund: json['fund'] as String? ?? '',
      ticker: json['ticker'] as String? ?? '',
      companyName: json['company'] as String? ?? json['company_name'] as String? ?? '',
      action: json['action'] as String? ?? json['type'] as String? ?? 'Buy',
      shares: json['shares'] as num? ?? 0,
    );
  }
}

class LeaderboardEntryModel {
  final int rank;
  final String politicianName;
  final String party;
  final String chamber;
  final num returnPercentage;
  final int tradeCount;
  final String? photoUrl;

  const LeaderboardEntryModel({
    required this.rank,
    required this.politicianName,
    required this.party,
    required this.chamber,
    required this.returnPercentage,
    required this.tradeCount,
    this.photoUrl,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      politicianName: json['name'] as String? ?? json['politician_name'] as String? ?? '',
      party: json['party'] as String? ?? '',
      chamber: json['chamber'] as String? ?? '',
      returnPercentage: json['return_pct'] as num? ?? json['return'] as num? ?? 0,
      tradeCount: (json['trade_count'] as num?)?.toInt() ?? 0,
      photoUrl: json['photo_url'] as String?,
    );
  }
}

class ConfluenceSignalModel {
  final String ticker;
  final String companyName;
  final String signalType; // Aligned / Divergent
  final int score;
  final String details;

  const ConfluenceSignalModel({
    required this.ticker,
    required this.companyName,
    required this.signalType,
    required this.score,
    required this.details,
  });

  factory ConfluenceSignalModel.fromJson(Map<String, dynamic> json) {
    return ConfluenceSignalModel(
      ticker: json['ticker'] as String? ?? '',
      companyName: json['company'] as String? ?? '',
      signalType: json['signal_type'] as String? ?? 'Aligned',
      score: (json['score'] as num?)?.toInt() ?? 0,
      details: json['details'] as String? ?? '',
    );
  }
}

class MotleyFoolModel {
  final String ticker;
  final String companyName;
  final String service;
  final String dateAdded;
  final num returnPct;

  const MotleyFoolModel({
    required this.ticker,
    required this.companyName,
    required this.service,
    required this.dateAdded,
    required this.returnPct,
  });

  factory MotleyFoolModel.fromJson(Map<String, dynamic> json) {
    return MotleyFoolModel(
      ticker: json['ticker'] as String? ?? '',
      companyName: json['company'] as String? ?? '',
      service: json['service'] as String? ?? '',
      dateAdded: json['date_added'] as String? ?? '',
      returnPct: json['return_pct'] as num? ?? 0,
    );
  }
}

class FaqItemModel {
  final String question;
  final String answer;
  final String? category;

  const FaqItemModel({
    required this.question,
    required this.answer,
    this.category,
  });

  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      question: json['question'] as String? ?? json['q'] as String? ?? '',
      answer: json['answer'] as String? ?? json['a'] as String? ?? '',
      category: json['category'] as String?,
    );
  }
}
