import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polytick_app/core/auth/auth_provider.dart';

// Features imports
import 'package:polytick_app/features/home/home_screen.dart';
import 'package:polytick_app/features/auth/login_screen.dart';

// Dashboard
import 'package:polytick_app/features/dashboard/dashboard_shell.dart';
import 'package:polytick_app/features/dashboard/congress_trades/congress_trades_screen.dart';
import 'package:polytick_app/features/dashboard/analytics/analytics_screen.dart';
import 'package:polytick_app/features/dashboard/leaderboard/leaderboard_screen.dart';
import 'package:polytick_app/features/dashboard/ark_invest/ark_screen.dart';
import 'package:polytick_app/features/dashboard/overlay/overlay_screen.dart';
import 'package:polytick_app/features/dashboard/motley_fool/motley_fool_screen.dart';
import 'package:polytick_app/features/dashboard/referrals/referrals_screen.dart';

// Trades
import 'package:polytick_app/features/trades/trade_history_screen.dart';
import 'package:polytick_app/features/trades/pelosi_trades_screen.dart';
import 'package:polytick_app/features/trades/tuberville_trades_screen.dart';
import 'package:polytick_app/features/trades/crenshaw_trades_screen.dart';
import 'package:polytick_app/features/trades/senator_trades_screen.dart';
import 'package:polytick_app/features/trades/most_profitable_screen.dart';

// Politicians
import 'package:polytick_app/features/politicians/politician_directory_screen.dart';
import 'package:polytick_app/features/politicians/politician_detail_screen.dart';

// Pricing
import 'package:polytick_app/features/pricing/pricing_screen.dart';

// Content
import 'package:polytick_app/features/blog/blog_list_screen.dart';
import 'package:polytick_app/features/blog/blog_detail_screen.dart';
import 'package:polytick_app/features/news/news_screen.dart';
import 'package:polytick_app/features/about/about_screen.dart';
import 'package:polytick_app/features/contact/contact_screen.dart';
import 'package:polytick_app/features/faq/faq_screen.dart';
import 'package:polytick_app/features/join/join_screen.dart';

// Legal
import 'package:polytick_app/features/legal/privacy_screen.dart';
import 'package:polytick_app/features/legal/terms_screen.dart';
import 'package:polytick_app/features/legal/disclaimer_screen.dart';
import 'package:polytick_app/features/legal/cookies_screen.dart';
import 'package:polytick_app/features/legal/data_sources_screen.dart';

// Misc & Help
import 'package:polytick_app/features/help_center/help_center_screens.dart';
import 'package:polytick_app/features/success/success_screen.dart';
import 'package:polytick_app/features/success/cancel_screen.dart';
import 'package:polytick_app/features/success/coaching_success_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoading = authState.loading;
      final isAuthenticated = authState.isAuthenticated;
      final hasSubscription = authState.subscription != null;
      final path = state.uri.path;

      if (isLoading) return null;

      // ── Authenticated User Guard ──
      // Redirect away from login/register screens if already signed in
      if (isAuthenticated && (path == '/login' || path == '/register')) {
        return '/dashboard/congress-trades';
      }

      final isProtected = path.startsWith('/dashboard');

      if (isProtected) {
        if (!isAuthenticated) {
          return '/login?returnTo=${Uri.encodeComponent(path)}';
        }
        if (!hasSubscription && !path.startsWith('/dashboard/referrals')) {
          return '/pricing';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Dashboard Shell ──
      ShellRoute(
        builder: (context, state, child) => DashboardShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            redirect: (context, state) => '/dashboard/congress-trades',
          ),
          GoRoute(
            path: '/dashboard/congress-trades',
            builder: (context, state) => const CongressTradesScreen(),
          ),
          GoRoute(
            path: '/dashboard/analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/dashboard/leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: '/dashboard/ark-invest',
            builder: (context, state) => const ArkScreen(),
          ),
          GoRoute(
            path: '/dashboard/overlay',
            builder: (context, state) => const OverlayScreen(),
          ),
          GoRoute(
            path: '/dashboard/motley-fool',
            builder: (context, state) => const MotleyFoolScreen(),
          ),
          GoRoute(
            path: '/dashboard/referrals',
            builder: (context, state) => const ReferralsScreen(),
          ),
        ],
      ),

      // ── Trades & Analytics ──
      GoRoute(
        path: '/trade-history',
        builder: (context, state) => const TradeHistoryScreen(),
      ),
      GoRoute(
        path: '/win',
        builder: (context, state) => const WINScreen(),
      ),
      GoRoute(
        path: '/most-profitable-trades',
        builder: (context, state) => const MostProfitableScreen(),
      ),
      GoRoute(
        path: '/pelosi-trades',
        builder: (context, state) => const PelosiTradesScreen(),
      ),
      GoRoute(
        path: '/tuberville-trades',
        builder: (context, state) => const TubervilleTradesScreen(),
      ),
      GoRoute(
        path: '/crenshaw-trades',
        builder: (context, state) => const CrenshawTradesScreen(),
      ),
      GoRoute(
        path: '/senator-trades',
        builder: (context, state) => const SenatorTradesScreen(),
      ),

      // ── Politicians ──
      GoRoute(
        path: '/politicians',
        builder: (context, state) => const PoliticianDirectoryScreen(),
      ),
      GoRoute(
        path: '/politicians/:slug',
        builder: (context, state) => PoliticianDetailScreen(
          slug: state.pathParameters['slug'] ?? '',
        ),
      ),

      // ── Pricing & Commerce ──
      GoRoute(
        path: '/pricing',
        builder: (context, state) => PricingScreen(
          initialPlan: state.uri.queryParameters['plan'],
          initialRef: state.uri.queryParameters['ref'],
        ),
      ),
      GoRoute(
        path: '/success',
        builder: (context, state) => SuccessScreen(
          sessionId: state.uri.queryParameters['session_id'],
        ),
      ),
      GoRoute(
        path: '/cancel',
        builder: (context, state) => const CancelScreen(),
      ),
      GoRoute(
        path: '/coaching-success',
        builder: (context, state) => CoachingSuccessScreen(
          sessionId: state.uri.queryParameters['session_id'],
        ),
      ),

      // ── Content & Info ──
      GoRoute(
        path: '/blog',
        builder: (context, state) => const BlogListScreen(),
      ),
      GoRoute(
        path: '/blog/:slug',
        builder: (context, state) => BlogDetailScreen(
          slug: state.pathParameters['slug'] ?? '',
        ),
      ),
      GoRoute(
        path: '/news',
        builder: (context, state) => const NewsScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/faq',
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: '/join',
        builder: (context, state) => const JoinScreen(),
      ),
      GoRoute(
        path: '/career',
        builder: (context, state) => const JoinScreen(),
      ),
      GoRoute(
        path: '/careers',
        builder: (context, state) => const JoinScreen(),
      ),
      GoRoute(
        path: '/api-access',
        builder: (context, state) => const ApiAccessScreen(),
      ),
      GoRoute(
        path: '/help-center',
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/documentation',
        builder: (context, state) => const DocumentationScreen(),
      ),

      // ── Legal ──
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/disclaimer',
        builder: (context, state) => const DisclaimerScreen(),
      ),
      GoRoute(
        path: '/cookies',
        builder: (context, state) => const CookiesScreen(),
      ),
      GoRoute(
        path: '/data-sources',
        builder: (context, state) => const DataSourcesScreen(),
      ),
    ],
  );
});
