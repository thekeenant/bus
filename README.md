# Event Bus on Dart

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

  // Subscribe a single handler
  bus.subscribe((Event event) {
    print('An event occurred at ${event.timestamp}.');
  });

  // post the event and (optional) await for handlers to receive them 
  await bus.post(new Event());
}
```

Also supported is subscribing a class full of handlers:

```dart
class GameListener implements Listener {
  @handler
  _onGame(GameEvent event) {
    print('[An event occurred at ${event.timestamp}]');
  }

  @handler
  _onChat(ChatEvent event) {
    print('${event.username} says "${event.message}"');
  }
}

...

bus.subscribeAll(new GameListener());
```

See the [game example][game] for explicit details.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[game]: https://github.com/thekeenant/dart-bus/blob/master/example/rxbus_game.dart
[tracker]: https://github.com/thekeenant/dart-bus/issues
