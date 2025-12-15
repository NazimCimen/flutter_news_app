import 'package:flutter/material.dart';

/// Custom shadows for the app
@immutable
final class CustomShadows {
  const CustomShadows._();

  /// Custom low shadow
  static List<Shadow> customLowShadow(BuildContext context) => [
    Shadow(
      offset: const Offset(1.5, 1.5),
      blurRadius: 2,
      color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.7),
    ),
  ];
}
