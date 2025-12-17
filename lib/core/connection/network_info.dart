import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// THIS PROVIDER IS USED TO CHECK INTERNET CONNECTION.
final internetConnectionCheckerProvider = Provider<InternetConnectionChecker>(
  (ref) => InternetConnectionChecker(),
);

final networkInfoProvider = Provider<INetworkInfo>((ref) {
  return NetworkInfo(ref.read(internetConnectionCheckerProvider));
});

/// INTERFACE FOR CHECK INTERNET CONNECTION.
abstract class INetworkInfo {
  Future<bool> get currentConnectivityResult;
}

///
class NetworkInfo implements INetworkInfo {
  final InternetConnectionChecker connectivity;

  NetworkInfo(this.connectivity);

  @override
  Future<bool> get currentConnectivityResult async {
    final result = await connectivity.hasConnection;
    if (result) {
      return true;
    } else {
      return false;
    }
  }
}
