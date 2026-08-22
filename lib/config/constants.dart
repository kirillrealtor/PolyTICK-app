/// App-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'PolyTICK';
  static const String appTagline = 'Track political trades with 8 layers of intelligence';
  static const String supportEmail = 'PolyTICK7@gmail.com';
  static const String websiteUrl = 'https://www.polytick.us';

  // ── Pricing ──
  static const double monthlyPrice = 14.99;
  static const double yearlyPrice = 149.99;
  static const double coachingPrice = 999.0;
  static const int trialDays = 14;

  // ── Auth ──
  static const int magicLinkPollIntervalMs = 2000;
  static const int resendCooldownSeconds = 30;
  static const int maxSendAttempts = 3;
  static const int sessionRefreshDays = 28;

  // ── Push Notifications ──
  /// Minimum trade amount_range upper bound to trigger push notification.
  /// Trades below this value are filtered out.
  static const int minTradeAmountForNotification = 50000;
  static const String tradeAlertsTopic = 'trade_alerts';

  // ── Social Links ──
  static const String twitterUrl = 'https://x.com/PolytickUS';
  static const String linkedinUrl = 'https://www.linkedin.com/company/polytick';
  static const String instagramUrl = 'https://www.instagram.com/polytick.us';
  static const String threadsUrl = 'https://www.threads.net/@polytick.us';
}
