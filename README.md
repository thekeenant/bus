# Event Bus on Dart

A light-weight event bus library for Dart implementing the pub-sub pattern.

**Note:** Bus does not currently function when compiled to javascript, as it depends on the Dart mirrors library
which is not yet complete.

![diagram](http://i.imgur.com/gBnIdO5.png)

Send a message to the bus and let the bus distribute the message to various handlers which are subscribed to that type of
event. This library utilizes the `Stream` async library in Dart to handle subscriptions and publishing messages.

## Install

See [pub.dartlang.org][install] for instructions on how to use bus in your project.

## Usage

A simple usage example:

```dart
import 'package:bus/bus.dart';

main() async {
  var bus = new Bus<String>();

  var sub = bus.subscribe((String message) {
    print('Received a string: "$message"');
  });

  await bus.post('Hey there!');
  
  // cancel the subscription
  sub.cancel();
  
  // the subscription was cancelled, this is pointless
  bus.post('This message will not be heard...');
}
```

Also supported is subscribing an object full of handlers:

```dart
class GameListener implements Listener {
  @handler
  void _onGame(GameEvent event) {
    print('[An event occurred at ${event.timestamp}]');
  }

  @handler
  void _onChat(ChatEvent event) {
    print('${event.username} says "${event.message}"');
  }
}

...

var bus = new Bus<GameEvent>();
var subs = bus.subscribeAll(new GameListener()); // returns a list of subscriptions

// remember to cancel your event subscriptions
subs.forEach((s) => s.cancel());
```

See the [game example][game] for explicit details.

For your synchronous needs, you can use `SyncBus` to publish and handle messages synchronously.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[install]: https://pub.dartlang.org/packages/bus#-pkg-tab-installing
[game]: https://github.com/thekeenant/dart-bus/blob/master/example/bus_game.dart
[tracker]: https://github.com/thekeenant/dart-bus/issues
