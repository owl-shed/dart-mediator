import 'request.dart';

abstract interface class IQuery<TResult> implements IRequest<TResult> {}

abstract interface class IQueryHandler<TQuery extends IQuery<TResult>, TResult>
    implements IRequestHandler<TQuery, TResult> {
  @override
  Future<TResult> handle(TQuery request);
}
