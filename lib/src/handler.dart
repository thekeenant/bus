/// Interface for all listeners to implement.
abstract class Listener {

}

/// @handler annotation
const Object handler = const Handler();

/// Used to indicate a method which should handle an event published to a bus.
class Handler {
  const Handler();
}