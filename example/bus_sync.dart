import 'package:bus/bus.dart';

class Event {
  final DateTime timestamp;

  Event() : this.timestamp = new DateTime.now();
}

main() {
  // Create a new bus that is synchronous.
  var bus = new SyncBus<Event>();

  // Subscribe
  var subscription = bus.subscribe((Event event) {
    print('An event occurred at ${event.timestamp}.');
  });

  // Publish the event
  bus.post(new Event());

  // Cancel the subscription
  subscription.cancel();
}
