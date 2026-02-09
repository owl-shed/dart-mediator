abstract interface class IRequest<TResult> {}

abstract interface class IRequestHandler<
  TRequest extends IRequest<TResult>,
  TResult
> {
  Future<TResult> handle(TRequest request);
}
