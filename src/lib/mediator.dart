/// Provides the architectural [Mediator] pattern, with CQRS support.
///
/// Mini-libraries:
/// - `commands.dart`:
/// 	- Use [ICommand] to define your commands and their result types.
/// 	- Use [ICommandHandler] to implement the handlers for your commands.
/// - `queries.dart`:
/// 	- Use [IQuery] to define your queries and their result types.
/// 	- Use [IQueryHandler] to implement the handlers for your queries.
library;

import 'commands.dart';
import 'queries.dart';
import 'src/mediator.dart';

export 'src/mediator.dart' show Mediator, EventSubscription;
