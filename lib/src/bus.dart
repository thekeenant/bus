import 'dart:async';
import 'dart:mirrors';

import 'handler.dart';

class Bus<T extends Object> {
  StreamController<T> _controller;

  /// Create a new bus.
  Bus() : _controller = new StreamController.broadcast();

  /// Subscribe a class of handlers
  List<StreamSubscription<T>> subscribeAll(Listener listener) {
    // List of subscriptions
    var rtn = <StreamSubscription<T>>[];

    InstanceMirror mirror = reflect(listener);

    mirror.type.declarations.forEach((sym, decl) {
      // Declaration must be a method
      if (!(decl is MethodMirror))
        return;

      MethodMirror method = decl as MethodMirror;

      bool isHandler = method.metadata.where((meta) => meta.reflectee is Handler).isNotEmpty;

      // @handler annotation must exist
      if (!isHandler)
        return;

      if (method.parameters.length != 1) {
        throw new ArgumentError('@handler methods must take exactly one argument');
      }
      InstanceMirror field = mirror.getField(sym);
      rtn.add(subscribe(field.reflectee));
    });

    return rtn;
  }

  /// Subscribe one handler
  StreamSubscription<T> subscribe(method<V extends T>(V event)) {
    ClosureMirror mirror = reflect(method);

    Type type = mirror.function.parameters.first.type.reflectedType;
    ClassMirror eventType;

    try {
      eventType = reflectType(type);
    }
    catch (e) {
      throw new ArgumentError('invalid closure provided');
    }

    // filter stream such that only subclasses are triggered
    Stream<T> filtered = _controller.stream.where((item) {
      ClassMirror itemClass = reflectType(item.runtimeType);
      return itemClass.isSubclassOf(eventType);
    });

    return filtered.listen((item) {
      method(item);
    });
  }

  /// Post an event to all current handlers on the bus.
  post(T event) async {
    await new Future.sync(() => _controller.add(event));
  }
}