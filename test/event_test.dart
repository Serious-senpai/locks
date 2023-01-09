import "dart:core";

import "package:async_locks/async_locks.dart";
import "package:test/test.dart";

import "utils.dart";

const futures_count = 5;

final event = Event();
final waiting = const Duration(seconds: 1);

Future<void> sampleFuture() async {
  await event.wait();
  await Future.delayed(waiting);
}

Future<void> mainFuture() async {
  await Future.delayed(waiting);
  event.set();
}

void main() {
  test(
    "Testing control flow",
    () async {
      var futures = <Future<void>>[];
      for (int i = 0; i < futures_count; i++) {
        futures.add(sampleFuture());
      }
      futures.add(mainFuture());

      var timer = Stopwatch();
      timer.start();
      await Future.wait(futures);
      timer.stop();

      expect(timer.elapsedMilliseconds, approximates(2000, 100));
    },
  );
}