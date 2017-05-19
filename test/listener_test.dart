import 'dart:async';

import 'package:bus/bus.dart';
import 'package:test/test.dart';

int _ints;
int _strings;
int _bools;

class MyListener {
  @handler
  _onInt(int message) {
    _ints++;
  }

  @handler
  _onString(String message) {
    _strings++;
  }

  @handler
  _onBool(bool message) {
    _bools++;
  }
}

void main() {
  SyncBus bus;

  setUp(() {
    bus = new SyncBus();
  });

  test("Listener test", () {
    var subs = bus.subscribeAll(new MyListener());
    _ints = 0;
    _strings = 0;
    _bools = 0;
    int count = 100;

    for (int i = 0; i < count; i++) {
      bus.post(i);  // int
      bus.post('$i');  // string
      bus.post(i.isEven);  // bool
    }

    expect(_ints, count);
    expect(_strings, count);
    expect(_bools, count);

    subs.forEach((sub) => sub.cancel());
  });
}