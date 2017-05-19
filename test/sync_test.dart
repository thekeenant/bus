import 'package:bus/bus.dart';
import "package:test/test.dart";

void main() {
  SyncBus<int> bus;

  setUp(() {
    bus = new SyncBus<int>();
  });

  test("Synchronous post in order", () {
    var start = 1;
    var end = 100;

    var current = start - 1;

    bus.subscribe((int num) {
      current++;
    });

    for (int i = start; i <= end; i++) {
      bus.post(i);

      // ensure synchronous, and in order
      expect(i, current);
    }

    // ensure receive them all
    expect(current, end);
  });
}