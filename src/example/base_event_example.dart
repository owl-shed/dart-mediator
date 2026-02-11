// Required only when you're creating a new event.
import 'package:owl_mediator/events.dart';

// Required when you want to use/initialise the mediator.
import 'package:owl_mediator/mediator.dart';

// Create the base event type, must implement IEvent.
// The event only needs fields if the event subscribers will require them.
abstract class MyBaseEvent implements IEvent {
  final String name;

  MyBaseEvent(this.name);
}

// Create a new derived event type, must implement IEvent (even if indirectly).
// The event only needs fields if the event subscribers will require them.
class NumberPickedEvent extends MyBaseEvent {
  final int number;

  NumberPickedEvent(this.number) : super("$NumberPickedEvent");
}

Future<void> main() async {
  // Create a new mediator, this should only be needed once per your application.
  Mediator mediator = Mediator();

  // Add base event type association. Hopefully this will be code generated in the future.
  // Dart doesn't currently have stable reflection that would allow for this to happen at runtime.
  mediator.associateBaseEvent<NumberPickedEvent, MyBaseEvent>();

  // Subscribe to base event.
  mediator.subscribe(
    (MyBaseEvent event) async => print("Event raised: ${event.name}"),
  );

  // Subscribe to the top level event.
  mediator.subscribe(
    (NumberPickedEvent event) async => print("Number picked: ${event.number}"),
  );

  // Raise the top level event, the base event will always be called later, even if it was registered first.
  await mediator.raise(NumberPickedEvent(123));
  // Prints:
  // Number picked: 123
  // Event raised: NumberPickedEvent
}
