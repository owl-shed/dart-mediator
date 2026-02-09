import 'request.dart';

abstract interface class ICommand<TResult> implements IRequest<TResult> {}

abstract interface class ICommandHandler<
  TCommand extends ICommand<TResult>,
  TResult
>
    implements IRequestHandler<TCommand, TResult> {
  @override
  Future<TResult> handle(TCommand request);
}
