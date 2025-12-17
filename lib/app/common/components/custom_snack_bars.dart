import 'package:flutter_news_app/app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// CUSTOM SNACK BARS
@immutable
final class CustomSnackBars {
  const CustomSnackBars._();

  /// SHOW THE CUSTOM BOTTOM SCAFFOLD SNACK BAR
  static void showCustomBottomScaffoldSnackBar({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        content: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.background),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }


  /// SHOW THE SUCCESS SNACK BAR
  static void showSuccess(BuildContext context, String message) {
    _hideCurrentSnackBar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: ValueKey('success_${DateTime.now().millisecondsSinceEpoch}'),
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  /// SHOW THE ERROR SNACK BAR
  static void showError(
    BuildContext context, {
    required String message,
    VoidCallback? action,
    String? actionLabel,
  }) {
    _hideCurrentSnackBar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: ValueKey('error_${DateTime.now().millisecondsSinceEpoch}'),
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),

        action: SnackBarAction(
          label: actionLabel ?? '',
          textColor: Colors.white,
          onPressed: action ?? () => _hideCurrentSnackBar(context),
        ),
      ),
    );
  }

  /// SHOW THE WARNING SNACK BAR
  static void showWarning(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    _hideCurrentSnackBar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: ValueKey('warning_${DateTime.now().millisecondsSinceEpoch}'),
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: backgroundColor ?? Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'StringConstants.close',
          textColor: Colors.white,
          onPressed: () => _hideCurrentSnackBar(context),
        ),
      ),
    );
  }

  /// HIDE THE CURRENT SNACK BAR
  static void _hideCurrentSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// HIDE ALL SNACK BARS
  static void hideAllSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}
