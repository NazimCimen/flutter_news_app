import 'package:flutter/foundation.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';

@immutable
final class TimeUtils {
  const TimeUtils._();

  /// Formats a date string to Turkish format with relative time
  /// Example: "12 Aralık Perşembe - 1 Saat Önce"
  static String formatNewsDate(String? publishedAt) {
    if (publishedAt == null) return '';

    try {
      final date = DateTime.parse(publishedAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      final day = date.day;
      final month = StringConstants.months[date.month - 1];
      final weekDay = StringConstants.weekDays[date.weekday - 1];

      // Zaman farkı
      String timeAgo;
      if (difference.inMinutes < 60) {
        timeAgo = '${difference.inMinutes} ${StringConstants.minutesAgo}';
      } else if (difference.inHours < 24) {
        timeAgo = '${difference.inHours} ${StringConstants.hoursAgo}';
      } else {
        timeAgo = '${difference.inDays} ${StringConstants.daysAgo}';
      }
      return '$day $month $weekDay - $timeAgo';
    } catch (e) {
      return '';
    }
  }
}
