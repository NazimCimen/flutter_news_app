/// THIS EXCEPTIONS ARE USED TO INDICATE EXCEPTIONS THAT OCCUR DURING THE EXECUTION OF A PROGRAM.
class ServerException implements Exception {
  ServerException(this.description);
  final String? description;
}

class CacheException implements Exception {
  CacheException(this.description);
  final String? description;
}

class ConnectionException implements Exception {
  ConnectionException(this.description);
  final String? description;
}

class UnKnownException implements Exception {
  UnKnownException(this.description);
  final String? description;
}

class AppVersionException implements Exception {
  AppVersionException(this.description);

  final String description;
  @override
  String toString() {
    return '$this $description';
  }
}
