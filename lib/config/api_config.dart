import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized API configuration.
/// All endpoint paths match the existing Next.js backend exactly.
class ApiConfig {
  ApiConfig._();

  /// Base URL loaded from .env (same as NEXT_PUBLIC_API_URL)
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ??
      'https://poly-insight-layers-production.up.railway.app';

  // ── Auth ──
  static const String magicLink = '/auth/magic-link';
  static const String pollMagicCode = '/auth/poll-magic-code';
  static const String confirmMagicCode = '/auth/confirm-magic-code';
  static const String refreshToken = '/auth/refresh-token';
  static const String register = '/auth/register';
  static const String deleteAccount = '/auth/delete-account';

  // ── Subscription ──
  static const String checkAccessSecure = '/check-access-secure';
  static const String checkAccess = '/check-access';
  static const String startFreeTrial = '/start-free-trial';
  static const String submitEmail = '/submit-email';

  // ── Stripe Checkout & Booking ──
  static const String createCheckoutSession = '/create-checkout-session';
  static const String createYearlyCheckoutSession = '/create-yearly-checkout-session';
  static const String createCoachingCheckoutSession = '/create-coaching-checkout-session';
  static const String getCheckoutEmail = '/get-checkout-email';
  static const String bookedSlots = '/booked-slots';
  static const String bookCoaching = '/book-coaching';
  static const String checkTrialEligibility = '/check-trial-eligibility';

  // ── Trades & Congress ──
  static const String congressTrades = '/congress-trades';
  static const String congressAnalytics = '/congress-trades/analytics';
  static const String senateTrades = '/senator-trades';
  static const String senateAnalytics = '/senator-trades/analytics';
  static const String politicianTrades = '/politician-trades';
  static const String politicianAnalytics = '/politician-trades/analytics';
  static const String tradeHistory = '/politicians';
  static const String mostProfitable = '/congress-trades';

  // ── Specific Member Shortcuts ──
  static const String pelosiTrades = '/politician-trades?search=Pelosi';
  static const String tubervilleTrades = '/politician-trades?search=Tuberville';
  static const String crenshawTrades = '/politician-trades?search=Crenshaw';

  // ── Politicians ──
  static const String politicians = '/politicians';
  static String politicianBySlug(String slug) => '/politicians?slug=$slug';

  // ── Analytics ──
  static const String analytics = '/analytics';
  static const String analyticsStats = '/analytics';

  // ── Leaderboard ──
  static const String leaderboard = '/stock-leaderboard';

  // ── ARK Invest & News ──
  static const String arkEtfTrades = '/ark/etf/trades';
  static const String arkEtfHoldings = '/ark/etf/holdings';
  static const String arkEtfProfile = '/ark/etf/profile';
  static const String arkEtfNews = '/ark/etf/news';
  static const String arkStockTrades = '/ark/stock/trades';
  static const String arkStockProfile = '/ark/stock/profile';
  static const String arkTrades = '/ark/etf/trades';

  // ── Overlay / Confluence ──
  static const String confluence = '/congress-trades';

  // ── Motley Fool ──
  static const String motleyFoolLong = '/motley-fool/long';
  static const String motleyFoolShort = '/motley-fool/short';
  static const String motleyFool = '/motley-fool/long';

  // ── Referrals ──
  static const String referrals = '/referral/dashboard';

  // ── Newsletter ──
  static const String newsletterSubscribe = '/newsletter/subscribe';

  // ── Contact ──
  static const String contact = '/contact';

  // ── Blog / News ──
  static const String blog = '/blog';
  static const String news = '/news';

  // ── Device Tokens (Push Notifications) ──
  static const String deviceTokens = '/device-tokens';

  // ── Scanned Filings (Admin) ──
  static const String scannedFilings = '/scanned-image-trades';
}
