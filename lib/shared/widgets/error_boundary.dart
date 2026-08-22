import 'package:flutter/material.dart';
import 'package:polytick_app/config/app_theme.dart';

class ErrorBoundaryWidget extends StatelessWidget {
  final String componentName;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorBoundaryWidget({
    super.key,
    this.componentName = 'Component',
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorBannerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.errorBannerBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.errorBannerText,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            'Error loading $componentName',
            style: AppTheme.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.errorBannerText,
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              errorMessage!,
              style: AppTheme.inter(
                fontSize: 13,
                color: AppTheme.errorBannerText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorBannerText,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }
}
