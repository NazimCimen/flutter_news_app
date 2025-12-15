import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final internetConnectionCheckerProvider = Provider<InternetConnectionChecker>((
  ref,
) {
  return InternetConnectionChecker();
});

final networkInfoProvider = Provider<INetworkInfo>((ref) {
  return NetworkInfo(ref.read(internetConnectionCheckerProvider));
});

/// this interface is used to control internet connection.
abstract class INetworkInfo {
  Future<bool> get currentConnectivityResult;
}

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
