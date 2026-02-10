import 'mediator.dart';

/// Implement to create an event that can be used with the [Mediator].
///
/// ```dart
/// // Create a new event, must implement [IEvent].
/// // The event only needs fields if your handlers will require them.
/// class NumberPickedEvent implements IEvent {
///   final int number;
///
///   NumberPickedEvent(this.number);
/// }
/// ```
abstract interface class IEvent {}
