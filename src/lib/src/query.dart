import 'request.dart';
import 'mediator.dart';

/// Implement to create a query that can be used with the [Mediator].
///
/// ```dart
/// // Create a new query, must implement IQuery<ResultType> only once.
/// // The query only needs fields if your handler will require them.
/// class GetAsStringQuery implements IQuery<String> {
///   final int number;

///   GetAsStringQuery(this.number);
/// }
/// ```
abstract interface class IQuery<TResult> implements IRequest<TResult> {}

/// Implement to create a handler for your custom [IQuery] implementation.
///
/// ```dart
/// // Create a new handler for your query, each query should get one, and only one handler.
/// // Multiple return types might be supported in the future.
/// class GetAsStringQueryHandler
///     implements IQueryHandler<GetAsStringQuery, String> {
///   @override
///   Future<String> handle(GetAsStringQuery request) {
///     // Put your handler implementation here.
///     // Handlers are async by default to allow for future middleware support.
///     String result = request.number.toString();
///     return Future.value(result);
///   }
/// }
/// ```
///
/// /// I recommend creating an extension method for your handler too,
/// *(this will hopefully be code-generated in the future)*:
///
/// ```dart
/// extension GetAsStringQueryMediator on Mediator {
///   Future<String> getAsString(int number) {
///     return runQuery(GetAsStringQuery(number));
///   }
/// }
///
/// Future<void> main() async {
///   // Create a new mediator, this should only be needed once per your application.
///   Mediator mediator = Mediator();
///
///   // Register the query handler for its query type.
///   // This will hopefully be code-generated later on.
///   mediator.registerQuery(GetAsStringQueryHandler());
///
///   // If you implemented the optional extension method, then you can do this instead.
///   String result = await mediator.getAsString(123);
///   print(result);
/// }
/// ```
abstract interface class IQueryHandler<TQuery extends IQuery<TResult>, TResult>
    implements IRequestHandler<TQuery, TResult> {
  @override
  Future<TResult> handle(TQuery request);
}
