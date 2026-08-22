import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:polytick_app/config/app_theme.dart';
import 'package:polytick_app/core/auth/auth_provider.dart';
import 'package:polytick_app/core/models/user_model.dart';
import 'package:polytick_app/shared/widgets/app_drawer.dart';
import 'package:polytick_app/shared/widgets/app_footer.dart';
import 'package:polytick_app/shared/widgets/profile_dropdown_modal.dart';
import 'package:polytick_app/shared/widgets/ticker_logo.dart';

class AppScaffold extends ConsumerStatefulWidget {
  final Widget body;
  final bool showFooter;
  final bool? showBackButton;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.showFooter = true,
    this.showBackButton,
    this.backgroundColor,
  });

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  // Stable GlobalKey preserved across rebuilds
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Dark status bar icons for Android
        statusBarBrightness: Brightness.light,    // Dark status bar text for iOS
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: widget.backgroundColor ?? AppTheme.bgDarkest,
        drawer: const AppDrawer(),
        endDrawer: const AppDrawer(),
        appBar: FigmaAppBar(
          scaffoldKey: _scaffoldKey,
          user: user,
          showBackButton: widget.showBackButton,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              widget.body,
              if (widget.showFooter) const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom Figma AppBar Widget with dark status bar options (time, wifi, battery) and back button
class FigmaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserModel? user;
  final bool? showBackButton;

  const FigmaAppBar({
    super.key,
    required this.scaffoldKey,
    this.user,
    this.showBackButton,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  void _openSideMenu(BuildContext context) {
    if (scaffoldKey.currentState?.hasEndDrawer ?? false) {
      scaffoldKey.currentState?.openEndDrawer();
    } else if (scaffoldKey.currentState?.hasDrawer ?? false) {
      scaffoldKey.currentState?.openDrawer();
    } else {
      try {
        Scaffold.of(context).openEndDrawer();
      } catch (_) {
        try {
          Scaffold.of(context).openDrawer();
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final isNotRoot = GoRouterState.of(context).matchedLocation != '/';
    final shouldShowBack = showBackButton ?? (canPop || isNotRoot);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000), // rgba(0,0,0,0.15)
            blurRadius: 25,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: preferredSize.height,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Back Button + Logo
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (shouldShowBack) ...[
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          context.go('/');
                        }
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black.withAlpha(15),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: const TickerLogo(scale: 0.95),
                  ),
                ],
              ),

              // Right: Avatar & Custom Figma Menu Icon
              Row(
                children: [
                  // 3D Avatar Circle (Opens User Profile Dropdown Modal)
                  GestureDetector(
                    onTap: () {
                      if (user == null) {
                        context.go('/login');
                      } else {
                        ProfileDropdownModal.show(context);
                      }
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: user != null ? const Color(0xFF3B82F6) : Colors.black.withAlpha(20),
                          width: user != null ? 1.5 : 1,
                        ),
                        boxShadow: user != null
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6).withAlpha(40),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                      child: ClipOval(
                        child: _buildUserAvatar(user),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Custom Figma Menu Icon with generous touch target
                  FigmaMenuIcon(
                    onTap: () => _openSideMenu(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(UserModel? user) {
    if (user == null) {
      return Container(
        color: const Color(0xFFF1F5F9),
        child: const Center(
          child: Icon(
            Icons.person_outline_rounded,
            size: 20,
            color: Color(0xFF64748B),
          ),
        ),
      );
    }

    if (user.photoURL != null && user.photoURL!.isNotEmpty) {
      return Image.network(
        user.photoURL!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _avatarFallback(user.initials),
      );
    }

    return _avatarFallback(user.initials);
  }

  Widget _avatarFallback(String initials) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTheme.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}

/// Custom Figma Menu Icon Widget with 48x48 generous touch target
class FigmaMenuIcon extends StatelessWidget {
  final VoidCallback onTap;

  const FigmaMenuIcon({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.black.withAlpha(15),
      highlightColor: Colors.black.withAlpha(10),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _menuLine(dotColor: const Color(0xFFC60C30)), // Top Red
            const SizedBox(height: 4.5),
            _menuLine(dotColor: const Color(0xFF51A2FF)), // Middle Blue
            const SizedBox(height: 4.5),
            _menuLine(dotColor: const Color(0xFFC60C30)), // Bottom Red
          ],
        ),
      ),
    );
  }

  Widget _menuLine({required Color dotColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Colored Dot (Red / Blue / Red)
        Container(
          width: 5.5,
          height: 5.5,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        // Horizontal Bar (#1E1E1E)
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
