import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Custom box decorations for the app
@immutable
final class CustomBoxDecoration {
  const CustomBoxDecoration._();

  /// Custom box decoration for image
  static BoxDecoration customBoxDecorationForImage(BuildContext context) {
    return BoxDecoration(
      borderRadius: context.borderRadiusAllLow,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      border: Border.all(
        color: Theme.of(context).colorScheme.tertiary,
        width: 2,
      ),
    );
  }

  /// Custom box decoration
  static BoxDecoration customBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: context.borderRadiusAllLow,
    );
  }

  /// Custom box decoration for top radius
  static BoxDecoration customBoxDecorationTopRadius(BuildContext context) {
    return BoxDecoration(
      border: const Border(top: BorderSide(color: AppColors.grey)),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(context.cMediumValue),
        topRight: Radius.circular(context.cMediumValue),
      ),
    );
  }

  /// Custom word card decoration
  static BoxDecoration customWordCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: context.borderRadiusAllMedium,
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        width: context.cSmallValue / 8,
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.03),
          blurRadius: context.cSmallValue,
          offset: Offset(0, context.cSmallValue / 4),
        ),
      ],
    );
  }
}
