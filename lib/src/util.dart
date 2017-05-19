import 'dart:mirrors';

import 'package:bus/src/handler.dart';

bool hasHandlerAnnotation(DeclarationMirror decl) {
  return decl.metadata.where((meta) => meta.reflectee is Handler).isNotEmpty;
}

List<InstanceMirror> handlerMethods(Listener listener) {
  InstanceMirror instance = reflect(listener);
  ClassMirror clazz = instance.type;

  var methods = <InstanceMirror>[];

  clazz.declarations.forEach((symbol, decl) {
    // Must be a method declaration
    if (!(decl is MethodMirror)) {
      return;
    }

    // Must have @handler
    if (!hasHandlerAnnotation(decl)) {
      return;
    }

    methods.add(instance.getField(symbol));
  });

  return methods;
}