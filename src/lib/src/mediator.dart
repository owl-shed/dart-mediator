import 'query.dart';
import 'command.dart';

class Mediator {
  final Map<Type, dynamic> _queryHandlers = {};
  final Map<Type, dynamic> _commandHandlers = {};

  void registerQuery<TQuery extends IQuery<TResult>, TResult>(
    IQueryHandler<TQuery, TResult> handler,
  ) {
    dynamic existing = _queryHandlers[TQuery];
    if (existing != null) {
      throw StateError(
        "A query handler has already been registered for the $TQuery type.",
      );
    }

    _queryHandlers[TQuery] = handler;
  }

  void registerCommand<TCommand extends ICommand<TResult>, TResult>(
    ICommandHandler<TCommand, TResult> handler,
  ) {
    dynamic existing = _commandHandlers[TCommand];
    if (existing != null) {
      throw StateError(
        "A command handler has already been registered for the $TCommand type.",
      );
    }

    _commandHandlers[TCommand] = handler;
  }

  Future<TResult> runQuery<TQuery extends IQuery<TResult>, TResult>(
    TQuery query,
  ) async {
    dynamic handler = _queryHandlers[TQuery];
    if (handler == null) {
      throw StateError(
        "No query handler has been registered for the $TQuery type.",
      );
    }

    IQueryHandler<TQuery, TResult> typedhandler = handler;
    return await typedhandler.handle(query);
  }

  Future<TResult> runCommand<TCommand extends ICommand<TResult>, TResult>(
    TCommand command,
  ) async {
    dynamic handler = _commandHandlers[TCommand];
    if (handler == null) {
      throw StateError(
        "No query handler has been registered for the $TCommand type.",
      );
    }

    ICommandHandler<TCommand, TResult> typedhandler = handler;
    return await typedhandler.handle(command);
  }
}
