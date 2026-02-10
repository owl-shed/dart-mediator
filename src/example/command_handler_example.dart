// Required only when you're creating a command / command handler.
import 'package:owl_mediator/commands.dart';

// Required when you want to use/initialise the mediator.
import 'package:owl_mediator/mediator.dart';

// Create a new command, must implement ICommand<ResultType> only once.
// The command only needs fields if your handler will require them.
class ConvertToStringCommand implements ICommand<String> {
  final int number;

  ConvertToStringCommand(this.number);
}

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

// OPTIONAL:
//	I recommend creating an extension method for your commands to make them
//	a tiny bit nicer to run. This will hopefully be code-generated later on.
extension ConvertToStringCommandMediator on Mediator {
  Future<String> convertToString(int number) {
    return runCommand(ConvertToStringCommand(number));
  }
}

Future<void> main() async {
  // Create a new mediator, this should only be needed once per your application.
  Mediator mediator = Mediator();

  // Register the command handler for its command type.
  // This will hopefully be code-generated later on.
  mediator.registerCommand(ConvertToStringCommandHandler());

  // Create and run your command.
  String result1 = await mediator.runCommand(ConvertToStringCommand(123));
  print(result1);

  // If you implemented the optional extension method, then you can do this instead.
  String result2 = await mediator.convertToString(123);
  print(result2);
}
