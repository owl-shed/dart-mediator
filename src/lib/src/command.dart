import 'request.dart';
import 'mediator.dart';

/// Implement to create a command that can be used with the [Mediator].
///
/// ```dart
/// // Create a new command, must implement ICommand<ResultType> only once.
/// // The command only needs fields if your handler will require them.
/// class ConvertToStringCommand implements ICommand<String> {
///   final int number;

///   ConvertToStringCommand(this.number);
/// }
/// ```
abstract interface class ICommand<TResult> implements IRequest<TResult> {}

/// Implement to create a handler for your custom [ICommand] implementation.
///
/// ```dart
/// // Create a new handler for your command, each command should get one, and only one handler.
/// // Multiple return types might be supported in the future.
/// class ConvertToStringCommandHandler
///     implements ICommandHandler<ConvertToStringCommand, String> {
///   @override
///   Future<String> handle(ConvertToStringCommand request) {
///     // Put your handler implementation here.
///     // Handlers are async by default to allow for future middleware support.
///     String result = request.number.toString();
///     return Future.value(result);
///   }
/// }
/// ```
///
/// I recommend creating an extension method for your handler too,
/// *(this will hopefully be code-generated in the future)*:
///
/// ```dart
/// extension ConvertToStringCommandMediator on Mediator {
///   Future<String> convertToString(int number) {
///     return runCommand(ConvertToStringCommand(number));
///   }
/// }
///
/// Future<void> main() async {
///   // Create a new mediator, this should only be needed once per your application.
///   Mediator mediator = Mediator();
///
///   // Register the query handler for its query type.
///   // This will hopefully be code-generated later on.
///   mediator.registerCommand(ConvertToStringQueryHandler());
///
///   // If you implemented the optional extension method, then you can do this instead.
///   String result = await mediator.convertToString(123);
///   print(result);
/// }
/// ```
abstract interface class ICommandHandler<
  TCommand extends ICommand<TResult>,
  TResult
>
    implements IRequestHandler<TCommand, TResult> {
  @override
  Future<TResult> handle(TCommand request);
}
