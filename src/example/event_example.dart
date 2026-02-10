import 'package:owl_mediator/events.dart';
import 'package:owl_mediator/mediator.dart';

class NumberPickedEvent implements IEvent {
  final int number;

  NumberPickedEvent(this.number);
}

Future<void> main() async {
  Mediator mediator = Mediator();

  mediator.subscribe<NumberPickedEvent>(
    (event) async => print("Number picked: ${event.number}"),
  );

  await mediator.raise(NumberPickedEvent(123));
}
