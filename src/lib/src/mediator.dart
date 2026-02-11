import 'query.dart';
import 'command.dart';
import 'event.dart';

typedef EventFuction<T> = Future<void> Function(T);
typedef WeakEventFunction = WeakReference<Object>;

/// Represents a token to an event subscription, can be used to manually unsubscribe from an event.
///
/// ```dart
/// mediator.unsubscribe(subscription);
/// ```
class EventSubscription {
  final Type _eventType;
  final WeakEventFunction _reference;

  EventSubscription._(this._eventType, this._reference);
}

/// An implementation for the architectural mediator pattern, with CQRS support.
///
/// ```dart
/// Future<void> main() async {
///   // Create a new mediator, this should only be needed once per your application.
///   Mediator mediator = Mediator();
///
///   // Register the command handler for its command type.
///   // This will hopefully be code-generated later on.
///   mediator.registerCommand(GetAsStringCommandHandler());
///
///   // Create and run your command.
///   String result = await mediator.runCommand(GetAsStringCommand(123));
///   print(result);
/// }
/// ```
class Mediator {
  final Map<Type, Object> _queryHandlers = {};
  final Map<Type, Object> _commandHandlers = {};
  final Map<Type, List<WeakEventFunction>> _eventSubscribers = {};
  final Map<Type, List<Type>> _baseEventAssociations = {};

  /// Registers an [IQueryHandler] for a custom [IQuery] type.
  ///
  /// Only a single handler can be registered for a specific [IQuery] type,
  /// if you try to register multiple handlers then a [StateError] will be thrown.
  void registerQuery<TQuery extends IQuery<TResult>, TResult>(
    IQueryHandler<TQuery, TResult> handler,
  ) {
    Object? existing = _queryHandlers[TQuery];
    if (existing != null) {
      throw StateError(
        "A query handler has already been registered for the $TQuery type.",
      );
    }

    _queryHandlers[TQuery] = handler;
  }

  /// Registers an [ICommandHandler] for a custom [ICommand] type.
  ///
  /// Only a single handler can be registered for a specific [ICommand] type,
  /// if you try to register multiple handlers then a [StateError] will be thrown.
  void registerCommand<TCommand extends ICommand<TResult>, TResult>(
    ICommandHandler<TCommand, TResult> handler,
  ) {
    Object? existing = _commandHandlers[TCommand];
    if (existing != null) {
      throw StateError(
        "A command handler has already been registered for the $TCommand type.",
      );
    }

    _commandHandlers[TCommand] = handler;
  }

  /// Executes the given [query] if a handler for it could be found,
  /// otherwise throws the [StateError].
  Future<TResult> runQuery<TQuery extends IQuery<TResult>, TResult>(
    TQuery query,
  ) async {
    Object? handler = _queryHandlers[TQuery];
    if (handler == null) {
      throw StateError(
        "No query handler has been registered for the $TQuery type.",
      );
    }

    IQueryHandler<TQuery, TResult> typedhandler =
        handler as IQueryHandler<TQuery, TResult>;
    return await typedhandler.handle(query);
  }

  /// Executes the given [command] if a handler for it could be found,
  /// otherwise throws the [StateError].
  Future<TResult> runCommand<TCommand extends ICommand<TResult>, TResult>(
    TCommand command,
  ) async {
    Object? handler = _commandHandlers[TCommand];
    if (handler == null) {
      throw StateError(
        "No query handler has been registered for the $TCommand type.",
      );
    }

    ICommandHandler<TCommand, TResult> typedhandler =
        handler as ICommandHandler<TCommand, TResult>;
    return await typedhandler.handle(command);
  }

  /// Subscribes a [callback] to be executed when the [TEvent] is raised.
  ///
  /// ```dart
  /// mediator.subscribe((TEvent event) async => doStuff(event));
  /// ```
  ///
  /// Events are raised with the [raise] function on the [Mediator].
  EventSubscription subscribe<TEvent extends IEvent>(
    EventFuction<TEvent> callback,
  ) {
    List<WeakEventFunction>? subscribers = _eventSubscribers[TEvent];
    if (subscribers == null) {
      subscribers = [];
      _eventSubscribers[TEvent] = subscribers;
    } else {
      // This only cleans up the GC'd subscribers for the current event but I think that's okay.
      List<WeakEventFunction> toRemove = [];
      for (WeakEventFunction ref in subscribers) {
        if (ref.target == null) toRemove.add(ref);
      }

      toRemove.forEach(subscribers.remove);
    }

    WeakEventFunction ref = WeakEventFunction(callback);
    subscribers.add(ref);

    return EventSubscription._(TEvent, ref);
  }

  void unsubscribe(EventSubscription subscription) {
    List<WeakEventFunction>? subscribers =
        _eventSubscribers[subscription._eventType];
    if (subscribers == null) return;

    List<WeakEventFunction> toRemove = [subscription._reference];

    for (WeakEventFunction ref in subscribers) {
      if (ref == subscription._reference) continue;
      if (ref.target == null) toRemove.add(ref);
    }

    toRemove.forEach(subscribers.remove);
    if (subscribers.isEmpty) _eventSubscribers.remove(subscription._eventType);
  }

  /// Raises the given [event].
  ///
  /// In order to subscribe to events use the [subscribe] function on the [Mediator].
  Future<void> raise<TEvent extends IEvent>(TEvent event) async {
    await _raiseForType(TEvent, event);
    await _raiseForBaseTypes(TEvent, event);
  }

  Future<void> _raiseForBaseTypes(Type type, dynamic event) async {
    List<Type>? baseTypes = _baseEventAssociations[type];
    if (baseTypes == null) return;

    for (Type baseType in baseTypes) {
      // Depth first, maybe breadth first would be better?
      await _raiseForType(baseType, event);
      await _raiseForBaseTypes(baseType, event);
    }
  }

  Future<void> _raiseForType(Type type, dynamic event) async {
    List<WeakEventFunction>? subscribers = _eventSubscribers[type];
    if (subscribers == null) return;

    // This only cleans up the GC'd subscribers for the current event but I think that's okay.
    List<WeakEventFunction> toRemove = [];
    for (WeakEventFunction ref in subscribers) {
      Object? target = ref.target;

      if (target == null) {
        toRemove.add(ref);
        continue;
      }

      dynamic callback = target;
      await callback.call(event);
    }

    toRemove.forEach(subscribers.remove);
    if (subscribers.isEmpty) _eventSubscribers.remove(type);
  }

  /// Associates a specific [Type] with it's base [Type].
  ///
  /// This can also be done for implemented interfaces rather than just for extended classes.
  /// Multiple assocations for a type are allowed *(such as if you used interfaces)*.
  /// Base event subscribers will always be called after the derived ones.
  ///
  /// ```dart
  /// mediator.associateBaseEvent<MyDerivedEvent, MyBaseEvent>();
  /// ```
  void associateBaseEvent<TSuper extends TBase, TBase extends IEvent>() {
    List<Type>? associations = _baseEventAssociations[TSuper];
    if (associations == null) {
      associations = [];
      _baseEventAssociations[TSuper] = associations;
    }

    if (associations.contains(TBase) == false) associations.add(TBase);
  }
}
