import 'package:flutter/foundation.dart';
import 'package:flutter_news_app/app/config/localization/string_constants.dart';

/// TIME UTILS IS USED TO MANAGE TIME FORMATTING
@immutable
final class TimeUtils {
  const TimeUtils._();

  //// FORMATS NEWS DATE AS "DAY MONTH WEEKDAY - TIME AGO"
  static String formatNewsDate(String? publishedAt) {
    if (publishedAt == null) return '';

    final date = DateTime.parse(publishedAt);
    final now = DateTime.now();
    final difference = now.difference(date);

    final day = date.day;
    final month = StringConstants.months[date.month - 1];
    final weekDay = StringConstants.weekDays[date.weekday - 1];

    String timeAgo;
    if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes} ${StringConstants.minutesAgo}';
    } else if (difference.inHours < 24) {
      timeAgo = '${difference.inHours} ${StringConstants.hoursAgo}';
    } else {
      timeAgo = '${difference.inDays} ${StringConstants.daysAgo}';
    }
    return '$day $month $weekDay - $timeAgo';
  }

  //// FORMATS RELATIVE TIME AGO STRING (E.G., "5 MINUTES AGO")
  static String formatTimeAgo(String? publishedAt) {
    if (publishedAt == null) return '';

    final date = DateTime.parse(publishedAt);
    final now = DateTime.now();
    final difference = now.difference(date);

    String timeAgo;
    if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes} ${StringConstants.minutesAgo}';
    } else if (difference.inHours < 24) {
      timeAgo = '${difference.inHours} ${StringConstants.hoursAgo}';
    } else {
      timeAgo = '${difference.inDays} ${StringConstants.daysAgo}';
    }
    return timeAgo;
  }
}
