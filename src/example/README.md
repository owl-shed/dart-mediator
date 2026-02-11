## Mediator

The `Mediator` class acts as the main entry point for this package, it doesn't
have any complex dependencies, and in order to use it you just have to create
an instance of it:
```dart
Mediator mediator = Mediator();
```

You probably only want a single instance of the mediator in your application.


## Commands and command handlers

In order to execute commands through the `Mediator` you have to:
1. Create your command:
   ```dart
   // Required only when you're creating a command / command handler.
   import 'package:owl_mediator/commands.dart';

   // Create a new command, must implement ICommand<ResultType> only once.
   // The command only needs fields if your handler will require them.
   class ConvertToStringCommand implements ICommand<String> {
     final int number;

     ConvertToStringCommand(this.number);
   }
   ```

2. Then your command handler:
   ```dart
   // Required only when you're creating a command / command handler.
   import 'package:owl_mediator/commands.dart';

   // Create a new handler for your command, each command should get one, and only one handler.
   // Multiple return types might be supported in the future.
   class ConvertToStringCommandHandler
       implements ICommandHandler<ConvertToStringCommand, String> {
     @override
     Future<String> handle(ConvertToStringCommand request) {
         // Put your handler implementation here.
         // Handlers are async by default to allow for future middleware support.
         String result = request.number.toString();
         return Future.value(result);
     }
   }
   ```

   Optionally you can also create an extension method that uses your command
   handler in order to make it easier to run the command:
   ```dart
   // Required to add an extension method on the mediator.
   import 'package:owl_mediator/mediator.dart';

   // OPTIONAL:
   //	I recommend creating an extension method for your commands to make them
   //	a tiny bit nicer to run. This will hopefully be code-generated later on.
   extension ConvertToStringCommandMediator on Mediator {
     Future<String> convertToString(int number) {
         return runCommand(ConvertToStringCommand(number));
     }
   }
   ```

3. Register the command handler on your mediator:
   ```dart
   // Required when you want to use/initialise the mediator.
   import 'package:owl_mediator/mediator.dart';

   void main() {
     // Create a new mediator, this should only be needed once per your application.
     Mediator mediator = Mediator();

     // Register the command handler for its command type.
     // This will hopefully be code-generated later on.
     mediator.registerCommand(ConvertToStringCommandHandler());
   }
   ```

4. Execute the command:
   ```dart
   // Create and run your command.
   String result1 = await mediator.runCommand(ConvertToStringCommand(123));
   print(result1);

   // If you implemented the optional extension method, then you can do this instead.
   String result2 = await mediator.convertToString(123);
   print(result2);
   ```


## Queries and query handlers

In order to execute queries through the `Mediator` you have to:
1. Create your query:
   ```dart
   // Required only when you're creating a query / query handler.
   import 'package:owl_mediator/queries.dart';

   // Create a new query, must implement IQuery<ResultType> only once.
   // The query only needs fields if your handler will require them.
   class GetAsStringQuery implements IQuery<String> {
     final int number;

     GetAsStringQuery(this.number);
   }
   ```

2. Then your query handler:
   ```dart
   // Required only when you're creating a query / query handler.
   import 'package:owl_mediator/queries.dart';

   // Create a new handler for your query, each query should get one, and only one handler.
   // Multiple return types might be supported in the future.
   class GetAsStringQueryHandler
       implements IQueryHandler<GetAsStringQuery, String> {
     @override
     Future<String> handle(GetAsStringQuery request) {
       // Put your handler implementation here.
       // Handlers are async by default to allow for future middleware support.
       String result = request.number.toString();
       return Future.value(result);
     }
   }
   ```

   Optionally you can also create an extension method that uses your query
   handler in order to make it easier to run the query:
   ```dart
   // Required to add an extension method on the mediator.
   import 'package:owl_mediator/mediator.dart';

   // OPTIONAL:
   //	I recommend creating an extension method for your queries to make them
   //	a tiny bit nicer to run. This will hopefully be code-generated later on.
   extension GetAsStringQueryMediator on Mediator {
     Future<String> getAsString(int number) {
         return runQuery(GetAsStringQuery(number));
     }
   }
   ```

3. Register the query handler on your mediator:
   ```dart
   // Required when you want to use/initialise the mediator.
   import 'package:owl_mediator/mediator.dart';

   void main() {
     // Create a new mediator, this should only be needed once per your application.
     Mediator mediator = Mediator();

     // Register the query handler for its query type.
     // This will hopefully be code-generated later on.
     mediator.registerQuery(GetAsStringQueryHandler());
   }
   ```

4. Execute the query:
   ```dart
   // Create and run your query.
   String result1 = await mediator.runQuery(GetAsStringQuery(123));
   print(result1);

   // If you implemented the optional extension method, then you can do this instead.
   String result2 = await mediator.getAsString(123);
   print(result2);
   ```


## Events

With the `Mediator` class you can also weakly subscribe to events and raise
them.

1. Create your event:
   ```dart
   // Required only when you're creating a new event.
   import 'package:owl_mediator/events.dart';

   // Create a new event, must implement IEvent.
   // The event only needs fields if the event subscribers will require them.
   class NumberPickedEvent implements IEvent {
     final int number;

     NumberPickedEvent(this.number);
   }
   ```

   Optionally you can also create an extension method to make raising your event
   slightly nicer:
   ```dart
   // Required to add an extension method on the mediator.
   import 'package:owl_mediator/mediator.dart';

   // OPTIONAL:
   //	I recommend creating an extension method for your events to make them
   //	a tiny bit nicer to raise. This will hopefully be code-generated later on.
   extension NumberPickedEventMediator on Mediator {
      Future<void> raiseNumberPicked(int number) {
         return raise(NumberPickedEvent(number));
      }
   }
   ```

2. Subscribe to the event:
   ```dart
   Future<void> main() async {
      // Create a new mediator, this should only be needed once per your application.
      Mediator mediator = Mediator();

      // Subscribe to the event, the callback will be called when the event is raised.
      // You DO NOT have to unsubscribe, [WeakReference] will take care of it for you.
      mediator.subscribe(
         (NumberPickedEvent event) async =>
            print("Number picked #1: ${event.number}"),
      );
   }
   ```

3. Raise the event:
   ```dart
   await mediator.raise(NumberPickedEvent(123));

   // If you implemented the optional extension method, then you can do this instead.
   await mediator.raiseNumberPicked(123);
   ```

4. Optionally unsubscribe from the event yourself instead of leaving it to Dart:
   ```dart
   // Get the subscription token from the [subscribe] function.
   EventSubscription subscription = mediator.subscribe(
      (NumberPickedEvent event) async =>
         print("Number picked #2: ${event.number}"),
   );

   // In order to unsubscribe you just pass in the subscription returned by [subscribe].
   mediator.unsubscribe(subscription);
   ```

The callbacks that you've subscribed with will be called in the order that they
were subscribed in.

### Base event types

It is also possible to subscribe to events of a base type, however for this
there is a little bit of boilerplate that's needed *(which will hopefully be
code generated later on).*

1. Create your base event type:
   ```dart
   // Create the base event type, must implement IEvent.
   // The event only needs fields if the event subscribers will require them.
   abstract class MyBaseEvent implements IEvent {
      final String name;

      MyBaseEvent(this.name);
   }
   ```

2. Make sure your derived event extends the base event:
   ```dart
   // Create a new derived event type, must implement IEvent (even if indirectly).
   // The event only needs fields if the event subscribers will require them.
   class NumberPickedEvent extends MyBaseEvent {
      final int number;

      NumberPickedEvent(this.number) : super("$NumberPickedEvent");
   }
   ```

3. Register the base event type association *(this will hopefully be
   code-generated in the future)*:
   ```dart
   void main() {
      // Create a new mediator, this should only be needed once per your application.
      Mediator mediator = Mediator();

      // Add base event type association. Hopefully this will be code generated in the future.
      // Dart doesn't currently have stable reflection that would allow for this to happen at runtime.
      mediator.associateBaseEvent<NumberPickedEvent, MyBaseEvent>();
   }
   ```

4. Subscribe to the events *(you don't have to subscribe to both)*:
   ```dart
   // Subscribe to base event.
   mediator.subscribe(
      (MyBaseEvent event) async => print("Event raised: ${event.name}"),
   );

   // Subscribe to the top level event.
   mediator.subscribe(
      (NumberPickedEvent event) async => print("Number picked: ${event.number}"),
   );
   ```

5. Raise the event:
   ```dart
   // Raise the top level event, the base event will always be called later, even if it was registered first.
   await mediator.raise(NumberPickedEvent(123));
   // Prints:
   // Number picked: 123
   // Event raised: NumberPickedEvent
   ```

6. It is also possible to have multiple base types if you use interfaces
   *(`implements` instead of `extends`)* when referring to your base types, this
   system also supports that, and all you have to do is associate multiple base
   events:
   ```dart
   mediator.associateBaseEvent<NumberPickedEvent, MyBaseEvent1>();
   mediator.associateBaseEvent<NumberPickedEvent, MyBaseEvent2>();
   ```

   Currently the base event subscriptions are called in a depth first manner,
   however this could switch to a breadth first manner in the future so don't
   rely on this behaviour.

   However the base event subscriptions will always be called after the derived
   event subscriptions, and this shouldn't need to change in the future.
