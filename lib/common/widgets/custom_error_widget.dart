import 'package:flutter/material.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';

/// Custom error widget for the app
/// [errorMsg] is the title of the error widget
/// [refreshOnPressed] is the callback for the refresh button
final class CustomErrorWidget extends StatelessWidget {
  final String errorMsg;
  final VoidCallback? refreshOnPressed;

  const CustomErrorWidget({
    required this.errorMsg,
    this.refreshOnPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.cLargeValue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.7),
            ),

            SizedBox(height: context.cLargeValue),
            Text(
              StringConstants.errorOccurred,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.outlineVariant,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: context.cMediumValue),

            Text(
              errorMsg,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outlineVariant,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (refreshOnPressed != null) ...[
              SizedBox(height: context.cLargeValue),

              // Refresh button
              ElevatedButton(
                onPressed: refreshOnPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.7),
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.cLargeValue * 1.2,
                    vertical: context.cMediumValue*0.9,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:context.cBorderRadiusAllLarge,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  StringConstants.tryAgain,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
