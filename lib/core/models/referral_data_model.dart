/// Referral data model — mirrors referralData state in AuthContext.
class ReferralDataModel {
  final double accountCredit;
  final String? referralCode;
  final bool hasUsedReferral;

  const ReferralDataModel({
    this.accountCredit = 0.0,
    this.referralCode,
    this.hasUsedReferral = false,
  });

  factory ReferralDataModel.empty() => const ReferralDataModel();

  factory ReferralDataModel.fromJson(Map<String, dynamic> json) {
    return ReferralDataModel(
      accountCredit: (json['account_credit'] as num?)?.toDouble() ?? 0.0,
      referralCode: json['referral_code'] as String?,
      hasUsedReferral: json['has_used_referral'] == true,
    );
  }
}
