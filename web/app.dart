import 'dart:html';

import 'package:bus/bus.dart';

var bus = new Bus<AppEvent>();

Element eventLog = document.querySelector('#event-log');

Element example1 = document.querySelector('#example1');
InputElement example1Input = document.querySelector('#example1-input');

InputElement example2Input = document.querySelector('#example2-input');

ButtonElement example3Button = document.querySelector('#example3-button');

var subscriptions = [];

class AppEvent {
  DateTime date;

  AppEvent() : this.date = new DateTime.now();
}

class TextChangeEvent extends AppEvent {
  final String message;

  TextChangeEvent(this.message);

  @override
  String toString() {
    return 'example 1 message changed: ${message}';
  }
}

class CheckboxChangeEvent extends AppEvent {
  final bool checked;

  CheckboxChangeEvent(this.checked);

  @override
  String toString() {
    return 'example 2 checkbox changed: ${checked}';
  }
}

class CancelSubscriptionsEvent extends AppEvent {
  @override
  String toString() {
    return 'All subscriptions cancelled! No more events :(';
  }
}

class ExampleListener {
  @handler
  void _onExample1(TextChangeEvent event) {
    example1.innerHtml = event.message;
  }

  @handler
  void _onExample3(CancelSubscriptionsEvent event) {
    subscriptions.forEach((s) => s.cancel());
  }
}

void registerEventLogger() {
  // listens to all events in the app
  var sub = bus.subscribe((AppEvent event) {
    eventLog.innerHtml = "<div><b>${event.date}</b>: ${event}</div>" + eventLog.innerHtml;
  });
  subscriptions.add(sub);
}

void registerListener() {
  subscriptions.addAll(bus.subscribeAll(new ExampleListener()));
}

void main() {
  registerEventLogger();
  registerListener();

  // post example 1 events
  example1Input.addEventListener('keyup', (Event event) {
    var text = example1Input.value;
    bus.post(new TextChangeEvent(text));
  });

  // post example 2 events
  example2Input.addEventListener('change', (Event event) {
    var checked = example2Input.checked;
    bus.post(new CheckboxChangeEvent(checked));
  });

  // post example 3 events
  example3Button.addEventListener('click', (Event event) {
    bus.post(new CancelSubscriptionsEvent());
  });
}