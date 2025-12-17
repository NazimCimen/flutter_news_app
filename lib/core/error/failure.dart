/// FAILURES ARE USED FOR DARTZ FAILURE PATTERN.
/// EITHER<FAILURE, T> IS USED TO INDICATE THAT A FUNCTION CAN RETURN A FAILURE OR A SUCCESS.
abstract class Failure {
  final String errorMessage;
  final String? errorCode;

  const Failure({required this.errorMessage, this.errorCode});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});
}

class CacheFailure extends Failure {
  CacheFailure({required super.errorMessage});
}

class ConnectionFailure extends Failure {
  ConnectionFailure({required super.errorMessage});
}

class UnKnownFaliure extends Failure {
  UnKnownFaliure({required super.errorMessage});
}

class InputNoImageFailure extends Failure {
  InputNoImageFailure({required super.errorMessage});
}

class AuthFailure extends Failure {
  AuthFailure({required super.errorMessage, super.errorCode});
}
