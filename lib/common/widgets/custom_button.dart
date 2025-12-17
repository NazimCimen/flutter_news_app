import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum ButtonType { elevated, outlined }

/// Custom button widget for authentication actions with loading state support
final class CustomButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final ButtonType buttonType;
  const CustomButtonWidget({
    required this.onPressed,
    required this.text,
    required this.isLoading,
    this.buttonType = ButtonType.elevated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: context.cXLargeValue * 1.8,

      child: buttonType == ButtonType.elevated
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(
                  vertical: context.cMediumValue * 0.95,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: context.cBorderRadiusAllSmall,
                ),
              ),
              onPressed: onPressed,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white
                      ),
                    ),
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: context.cMediumValue * 0.95,
                ),
                side: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: context.cBorderRadiusAllSmall,
                ),
              ),
              onPressed: onPressed,
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.primary,
                      ),
                    )
                  : Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
    );
  }
}
