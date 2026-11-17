import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True when the phone has a network connection. Starts optimistic so the
/// offline banner does not flash on launch.
final isOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  bool online(List<ConnectivityResult> r) => r.any((x) => x != ConnectivityResult.none);
  yield online(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(online);
});
