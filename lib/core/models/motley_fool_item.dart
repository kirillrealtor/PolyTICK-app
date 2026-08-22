class MotleyFoolItem {
  final int? rank;
  final String companyName;
  final String ticker;
  final String? heldByFools;

  const MotleyFoolItem({
    this.rank,
    required this.companyName,
    required this.ticker,
    this.heldByFools,
  });

  factory MotleyFoolItem.fromJson(Map<String, dynamic> json) {
    return MotleyFoolItem(
      rank: (json['rank'] as num?)?.toInt(),
      companyName: json['company_name'] as String? ?? json['company'] as String? ?? '',
      ticker: json['ticker'] as String? ?? '',
      heldByFools: json['held_by_fools']?.toString(),
    );
  }
}
