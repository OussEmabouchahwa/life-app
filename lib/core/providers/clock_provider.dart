import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits the current time now and then every 30 seconds.
/// Countdowns and the NOW marker watch this instead of calling DateTime.now()
/// in build methods, so they refresh on their own and are easy to fake in tests.
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
});

/// Synchronous read of the clock with a fallback while the stream starts.
final nowProvider = Provider<DateTime>((ref) => ref.watch(clockProvider).value ?? DateTime.now());
