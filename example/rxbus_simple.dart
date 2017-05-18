import 'package:rxbus/rxbus.dart';

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
