import 'package:flutter_news_app/core/utils/size/constant_size.dart';
import 'package:flutter_news_app/core/utils/size/app_border_radius_extensions.dart';
import 'package:flutter/material.dart';

/// Custom input decorations for the app
@immutable
final class CustomInputDecoration {
  const CustomInputDecoration._();

  /// Custom input decoration
  static InputDecoration customInputDecoration({
    required BuildContext context,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hintText,
    filled: true,
    fillColor: const Color(0xFF1c2127),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  );

  /// Custom auth input decoration
  static InputDecoration authInputDecoration({
    required BuildContext context,
    required String hintText,
    Widget? suffixIcon,
  }) => InputDecoration(
    filled: true,
    fillColor: const Color(0xFF1c2127),
    hintText: hintText,
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
    ),
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.symmetric(
      horizontal: context.cMediumValue,
      vertical: context.cMediumValue,
    ),
    border: OutlineInputBorder(
      borderRadius: context.cBorderRadiusAllLow,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: context.cBorderRadiusAllLow,
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: context.cBorderRadiusAllLow,
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: context.cBorderRadiusAllLow,
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}
