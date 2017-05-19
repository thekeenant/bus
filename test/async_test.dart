import 'dart:async';

import 'package:bus/bus.dart';
import 'package:test/test.dart';

void main() {
  Bus<int> bus;

  setUp(() {
    bus = new Bus<int>();
  });

  test("Async post in order", () async {
    var start = 1;
    var end = 100;

    var current = start - 1;

    bus.subscribe((int num) {
      current++;

      // ensure receive them in order
      expect(num, current);
    });

    for (int i = start; i <= end; i++) {
      bus.post(i);
    }

    // should still be at start (async)
    expect(current, start - 1);

    await new Future.delayed(const Duration(seconds: 1), () {
      // afterwards, should be at the end
      expect(current, end);
    });
  });
}