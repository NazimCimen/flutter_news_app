import 'package:flutter/material.dart';
import 'package:flutter_news_app/app/config/theme/app_colors.dart';

/// COLOR UTILS IS USED TO MANAGE COLORS
@immutable
final class ColorUtils {
  const ColorUtils._();

  /// RETURNS A COLOR FROM A HEX COLOR CODE OR A FALLBACK COLOR
  static Color getCategorButtonColor(String? colorCode) {
    if (colorCode != null) {
      return Color(int.parse(colorCode.replaceFirst('#', '0xFF')));
    } else {
      return AppColors.secondaryColor;
    }
  }

  /// RETURNS BLACK OR WHITE TEXT COLOR BASED ON BACKGROUND BRIGHTNESS
  static Color getContrastTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
