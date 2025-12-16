import 'package:flutter/material.dart';
import 'package:flutter_news_app/config/theme/app_colors.dart';

@immutable
final class ColorUtils {
  const ColorUtils._();

  /// Returns a color from a hex color code or a fallback color
  static Color getCategorButtonColor(String? colorCode) {
    if (colorCode != null) {
      return Color(int.parse(colorCode.replaceFirst('#', '0xFF')));
    } else {
      return AppColors.secondaryColor;
    }
  }

  /// Returns black or white text color based on background brightness
  static Color getContrastTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
