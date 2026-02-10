/// Represents the base unit type for commands and queries, you shouldn't implement this interface directly.
///
/// You can however use it if you want to generically work with both commands and queries.
abstract interface class IRequest<TResult> {}

/// Represents the base unit type for command and query handlers, you shouldn't implement this interface directly.
///
/// You can however use it if you want to generically work with both command and query handlers.
abstract interface class IRequestHandler<
  TRequest extends IRequest<TResult>,
  TResult
> {
  Future<TResult> handle(TRequest request);
}
