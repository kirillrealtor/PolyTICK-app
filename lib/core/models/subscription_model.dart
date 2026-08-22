/// Subscription model — equivalent of the subscription state in AuthContext.
class SubscriptionModel {
  final String status;
  final bool isTrial;
  final int daysRemaining;
  final String? productName;

  final String? interval;

  const SubscriptionModel({
    required this.status,
    this.isTrial = false,
    this.daysRemaining = 0,
    this.productName,
    this.interval,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      status: json['status'] as String? ?? 'inactive',
      isTrial: json['is_trial'] == true,
      daysRemaining: (json['days_remaining'] as num?)?.toInt() ?? 0,
      productName: json['product_name'] as String?,
      interval: json['interval'] as String?,
    );
  }

  bool get isActive => status == 'active';
  bool get isMonthly => interval == 'month' || (productName != null && productName!.toLowerCase().contains('monthly'));
  bool get isYearly => interval == 'year' || (productName != null && productName!.toLowerCase().contains('yearly'));
  bool get isCoaching => (productName != null && productName!.toLowerCase().contains('coaching'));
}
