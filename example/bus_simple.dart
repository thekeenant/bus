import 'package:bus/bus.dart';

main() async {
  var bus = new Bus<String>();

  var subscription = bus.subscribe((String message) {
    print('Received a string: "$message"');
  });

  await bus.post('Hey there!');

  // unsubscribe
  await subscription.cancel();

  // do other stuff...
}
