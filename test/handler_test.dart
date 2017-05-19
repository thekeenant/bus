import 'dart:async';

import 'package:bus/bus.dart';
import 'package:test/test.dart';

void main() {
  SyncBus bus;

  setUp(() {
    bus = new SyncBus();
  });

  test("Handler test", () {
    int ints = 0;
    int strings = 0;
    int bools = 0;
    int count = 100;

    var sub1 = bus.subscribe((int msg) {
      ints++;
    });

    var sub2 = bus.subscribe((String msg) {
      strings++;
    });

    var sub3 = bus.subscribe((bool msg) {
      bools++;
    });

    for (int i = 0; i < count; i++) {
      bus.post(i);  // int
      bus.post('$i');  // string
      bus.post(i.isEven);  // bool
    }

    expect(ints, count);
    expect(strings, count);
    expect(bools, count);

    sub1.cancel();
    sub2.cancel();
    sub3.cancel();
  });
}