import 'package:bus/bus.dart';

main() async {
  var bus = new Bus<String>();

  bus.subscribe((String message) {
    print('Received a string: "$message"');
  });

  await bus.post('Hey there!');
}
