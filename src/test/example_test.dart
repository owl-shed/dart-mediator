import 'package:test/test.dart';

import '../example/command_handler_example.dart' as command_handler_example;
import '../example/query_handler_example.dart' as query_handler_example;
import '../example/event_example.dart' as event_example;
import '../example/base_event_example.dart' as base_event_example;

// I'm assuming if a test throws an error/exception then it's marked as failed but I'm not actually sure...

void main() {
  group("Example", () {
    test(" command handler", () async {
      await command_handler_example.main();
    });

    test(" query handler", () async {
      await query_handler_example.main();
    });

    test(" event", () async {
      await event_example.main();
    });

    test(" base event", () async {
      await base_event_example.main();
    });
  });
}
