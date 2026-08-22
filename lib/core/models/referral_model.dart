class ReferralRecord {
  final String? refereeEmail;
  final String status;
  final String? createdAt;
  final String? convertedAt;
  final num creditEarned;

  const ReferralRecord({
    this.refereeEmail,
    required this.status,
    this.createdAt,
    this.convertedAt,
    this.creditEarned = 0,
  });

  factory ReferralRecord.fromJson(Map<String, dynamic> json) {
    num parsedCredit = 0;
    if (json['credit_earned'] is num) {
      parsedCredit = json['credit_earned'];
    } else if (json['credit_earned'] is String) {
      parsedCredit = num.tryParse(json['credit_earned']) ?? 0;
    }

    return ReferralRecord(
      refereeEmail: json['referee_email']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString(),
      convertedAt: json['converted_at']?.toString(),
      creditEarned: parsedCredit,
    );
  }
}

class ReferralDashboardData {
  final String? referralCode;
  final num accountCredit;
  final num totalCreditEarned;
  final List<ReferralRecord> referrals;

  const ReferralDashboardData({
    this.referralCode,
    this.accountCredit = 0,
    this.totalCreditEarned = 0,
    this.referrals = const [],
  });

  factory ReferralDashboardData.fromJson(Map<String, dynamic> json) {
    num parsedAccountCredit = 0;
    if (json['account_credit'] is num) {
      parsedAccountCredit = json['account_credit'];
    } else if (json['account_credit'] is String) {
      parsedAccountCredit = num.tryParse(json['account_credit']) ?? 0;
    }

    num parsedTotalCredit = 0;
    if (json['total_credit_earned'] is num) {
      parsedTotalCredit = json['total_credit_earned'];
    } else if (json['total_credit_earned'] is String) {
      parsedTotalCredit = num.tryParse(json['total_credit_earned']) ?? 0;
    }

    final rawList = json['referrals'];
    final list = <ReferralRecord>[];
    if (rawList is List) {
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          list.add(ReferralRecord.fromJson(item));
        } else if (item is Map) {
          list.add(ReferralRecord.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return ReferralDashboardData(
      referralCode: json['referral_code']?.toString(),
      accountCredit: parsedAccountCredit,
      totalCreditEarned: parsedTotalCredit,
      referrals: list,
    );
  }
}
