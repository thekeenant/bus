import 'dart:async';
import 'dart:mirrors';

import 'handler.dart';
import 'util.dart';

/// A synchronous bus.
class SyncBus<T extends Object> extends _AbstractBus<T> {
  SyncBus() : super(new StreamController.broadcast(sync: true));

  /// Post an event to all current handlers on the bus synchronously.
  void post(T event) {
    _controller.add(event);
  }
}

/// An asynchronous bus.
class Bus<T extends Object> extends _AbstractBus<T> {
  Bus() : super(new StreamController.broadcast(sync: false));

  /// Post an event to all current handlers on the bus, asynchronously.
  Future<Null> post(T event) async {
    await new Future.sync(() => _controller.add(event));
  }
}

abstract class _AbstractBus<T extends Object> {
  StreamController<T> _controller;

  /// Create a new bus
  _AbstractBus(this._controller);

  /// The type of message that can be published
  Type get messageType {
    return reflect(this).type.typeArguments.first.reflectedType;
  }

  /// Subscribe one handler
  StreamSubscription<V> subscribe<V extends T>(void handlerMethod(V event), {bool typeCheck = true}) {
    ClosureMirror mirror = reflect(handlerMethod);

    if (mirror.function.parameters.length != 1)
      throw new ArgumentError('handlers must take exactly one argument');

    Type type = mirror.function.parameters.first.type.reflectedType;
    var eventType = reflectType(type);
    var filter;

    // type is specified
    if (eventType is ClassMirror) {
      if (typeCheck && !eventType.isSubtypeOf(reflectType(messageType))) {
        throw new ArgumentError('handler event parameter type is invalid (typeCheck = true)');
      }

      filter = (item) {
        ClassMirror itemClass = reflectType(item.runtimeType);
        return itemClass.isSubtypeOf(eventType);
      };
    }
    // none specified
    else if (eventType is TypeMirror) {
      // accept all events
      filter = (item) => true;
    }
    else {
      throw new ArgumentError('invalid handler parameters');
    }

    // filter stream such that only subclasses are triggered
    var filtered = _controller.stream.where(filter);

    return filtered.listen((item) => handlerMethod(item));
  }

  /// Subscribe a class of handlers
  List<StreamSubscription<T>> subscribeAll(Listener listener) {
    var methods = handlerMethods(listener);
    return methods.map((mirror) => subscribe(mirror.reflectee, typeCheck: false)).toList();
  }
}