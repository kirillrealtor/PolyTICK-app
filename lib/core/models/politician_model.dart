class PoliticianModel {
  final String name;
  final String slug;
  final String party;
  final String chamber;
  final String state;
  final String? photoUrl;
  final int? totalTrades;
  final String? winRate;

  const PoliticianModel({
    required this.name,
    required this.slug,
    required this.party,
    required this.chamber,
    required this.state,
    this.photoUrl,
    this.totalTrades,
    this.winRate,
  });

  factory PoliticianModel.fromJson(Map<String, dynamic> json) {
    return PoliticianModel(
      name: json['name'] as String? ?? json['politician_name'] as String? ?? '',
      slug: json['slug'] as String? ?? json['politician_slug'] as String? ?? '',
      party: json['party'] as String? ?? '',
      chamber: json['chamber'] as String? ?? '',
      state: json['state'] as String? ?? '',
      photoUrl: json['photo_url'] as String? ?? json['image_url'] as String?,
      totalTrades: (json['total_trades'] as num?)?.toInt(),
      winRate: json['win_rate'] as String?,
    );
  }
}
