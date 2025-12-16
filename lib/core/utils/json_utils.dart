import 'package:flutter/foundation.dart';

/// JSON transformation utilities
@immutable
final class JsonUtils {
  const JsonUtils._();

  /// Backend sometimes sends field names with underscores (_id, _title, etc.)
  /// This function removes underscores to convert to standard format
  ///
  /// Example:
  /// ```dart
  /// {'_id': '123', '_title': 'Hello'} -> {'id': '123', 'title': 'Hello'}
  /// ```
  static Map<String, dynamic> removeUnderscores(Map<String, dynamic> json) {
    final cleaned = <String, dynamic>{};
    json.forEach((key, value) {
      final cleanKey = key.startsWith('_') ? key.substring(1) : key;
      cleaned[cleanKey] = value;
    });
    return cleaned;
  }
}
