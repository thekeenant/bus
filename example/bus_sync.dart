import 'package:bus/bus.dart';


main() {
  // Create a new bus that is synchronous.
  var bus = new SyncBus<int>();

  // Subscribe
  var subscription = bus.subscribe((int msg) {
    print('Got the number: $msg');
  });

  // Publish the events
  bus.post(1);
  bus.post(2);
  bus.post(3);

  // Cancel the subscription
  subscription.cancel();
}
