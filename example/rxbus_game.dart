import 'package:rxbus/rxbus.dart';

/// A generic event which all events extend.
abstract class GameEvent {
  final DateTime timestamp;

  GameEvent() : this.timestamp = new DateTime.now();
}

/// Called when a player chats.
class ChatEvent extends GameEvent {
  final String username, message;

  ChatEvent(this.username, this.message);
}

/// Called when a player jumps.
class JumpEvent extends GameEvent {
  final String username;

  JumpEvent(this.username);
}

/// Listens to various game events.
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

main() async {
  // Create a new bus.
  var bus = new Bus<GameEvent>();

  // Register all annotated methods in game listener.
  bus.subscribeAll(new GameListener());

  // Listen to a specific event type.
  var sub = bus.subscribe((JumpEvent event) {
    print('${event.username} jumped.');
  });

  // Post the event, wait for handlers to receive them.
  await bus.post(new JumpEvent("Billy"));

  // We can cancel a listener.
  // Note: "await" was used above so that we don't cancel the handler before
  // it is actually handled
  sub.cancel();

  // Post another event.
  // Note: "await" is used to prevent the thread from shutting down before the
  // handlers recieve them
  await bus.post(new ChatEvent("Billy", "Hey, this is a chat message!"));
}
