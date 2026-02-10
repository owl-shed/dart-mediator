// Required only when you're creating a new event.
import 'package:owl_mediator/events.dart';

// Required when you want to use/initialise the mediator.
import 'package:owl_mediator/mediator.dart';

// Create a new event, must implement IEvent.
// The event only needs fields if the event subscribers will require them.
class NumberPickedEvent implements IEvent {
  final int number;

  NumberPickedEvent(this.number);
}

// OPTIONAL:
//	I recommend creating an extension method for your events to make them
//	a tiny bit nicer to raise. This will hopefully be code-generated later on.
extension NumberPickedEventMediator on Mediator {
  Future<void> raiseNumberPicked(int number) {
    return raise(NumberPickedEvent(number));
  }
}

Future<void> main() async {
  // Create a new mediator, this should only be needed once per your application.
  Mediator mediator = Mediator();

  // Subscribe to the event, the callback will be called when the event is raised.
  // You DO NOT have to unsubscribe, [WeakReference] will take care of it for you.
  mediator.subscribe(
    (NumberPickedEvent event) async =>
        print("Number picked #1: ${event.number}"),
  );

  // Callbacks will be called in the order in which they are subscribed in.
  // You can also manually unsubscribe if you wish to do it earlier for example.
  EventSubscription<NumberPickedEvent> subscription = mediator.subscribe(
    (NumberPickedEvent event) async =>
        print("Number picked #2: ${event.number}"),
  );

  await mediator.raise(NumberPickedEvent(123));
  // Prints:
  // Number picked #1: 123
  // Number picked #2: 123

  // If you implemented the optional extension method, then you can do this instead.
  await mediator.raiseNumberPicked(123);

  // In order to unsubscribe you just pass in the subscription returned by [subscribe].
  mediator.unsubscribe(subscription);
}
