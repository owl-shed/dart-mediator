// Required only when you're creating a query / query handler.
import 'package:owl_mediator/query.dart';

// Required when you want to use/initialise the mediator.
import 'package:owl_mediator/mediator.dart';

// Create a new query, must implement IQuery<ResultType> only once.
// The query only needs fields if your handler will require them.
class GetAsStringQuery implements IQuery<String> {
  final int number;

  GetAsStringQuery(this.number);
}

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

// OPTIONAL:
//	I recommend creating an extension method for your queries to make them
//	a tiny bit nicer to run. This will hopefully be code-generated later on.
extension GetAsStringQueryMediator on Mediator {
  Future<String> getAsString(int number) {
    return runQuery(GetAsStringQuery(number));
  }
}

Future<void> main() async {
  // Create a new mediator, this should only be needed once per your application.
  Mediator mediator = Mediator();

  // Register the query handler for its query type.
  // This will hopefully be code-generated later on.
  mediator.registerQuery(GetAsStringQueryHandler());

  // Create and run your query.
  String result1 = await mediator.runQuery(GetAsStringQuery(123));
  print(result1);

  // If you implemented the optional extension method, then you can do this instead.
  String result2 = await mediator.getAsString(123);
  print(result2);
}
