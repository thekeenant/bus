# dart-bus

A light-weight event bus library for Dart implementing the pub-sub pattern.

## Usage

A simple usage example:

```dart
import 'package:bus/bus.dart';

class Event {
  final DateTime timestamp;

  Event() : this.timestamp = new DateTime.now();
}

main() async {
  // Create a new bus.
  var bus = new Bus<Event>();

  bus.subscribe((Event event) {
    print('An event occurred at ${event.timestamp}.');
  });

  await bus.post(new Event());
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/thekeenant/dart-bus/issues
