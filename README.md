# Event Bus on Dart

A light-weight event bus library for Dart implementing the pub-sub pattern.

## Install

See [pub.dartlang.org][install] for instructions on how to use bus in your project.

## Usage

A simple usage example:

```dart
import 'package:bus/bus.dart';

class Event {
  final DateTime timestamp;

  Event() : this.timestamp = new DateTime.now();
}

main() async {
  // Create a new bus, which accepts messages of type Event.
  var bus = new Bus<Event>();

  // Subscribe a single handler
  bus.subscribe((Event event) {
    print('An event occurred at ${event.timestamp}.');
  });

  // Post the event and (optional) await for handlers to receive them 
  await bus.post(new Event());
}
```

Also supported is subscribing a object full of handlers:

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

For your synchronous needs, you can use `SyncBus` to publish and handle messages synchronously.

See the [game example][game] for explicit details.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[install]: https://pub.dartlang.org/packages/bus#-pkg-tab-installing
[game]: https://github.com/thekeenant/dart-bus/blob/master/example/rxbus_game.dart
[tracker]: https://github.com/thekeenant/dart-bus/issues