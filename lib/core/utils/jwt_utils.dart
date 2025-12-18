import 'dart:convert';
import 'package:flutter/foundation.dart';

/// JWT UTILS USED TO CHECK IF THE TOKEN IS EXPIRED
@immutable
final class JwtUtils {
  const JwtUtils._();
  static bool isTokenExpired(String token) {
    try {
      final expiry = _getExpiryDate(token);
      if (expiry == null) return true;

      final nowUtc = DateTime.now().toUtc();
      return nowUtc.isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  static DateTime? _getExpiryDate(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final decoded = _decodeBase64(payload);
      final jsonMap = json.decode(decoded) as Map<String, dynamic>;

      final exp = jsonMap['exp'] as int?;
      if (exp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (_) {
      return null;
    }
  }

  static String _decodeBase64(String str) {
    var output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
      case 3:
        output += '=';
    }

    return utf8.decode(base64Url.decode(output));
  }
}
