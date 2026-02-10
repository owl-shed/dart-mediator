import 'package:test/test.dart';
import '../example/command_handler_example.dart' as command_handler;
import '../example/query_handler_example.dart' as query_handler;

// I'm assuming if a test throws an error/exception then it's marked as failed but I'm not actually sure...

void main() {
  group("Example", () {
    test(" command handler", () async {
      await command_handler.main();
    });

    test(" query handler", () async {
      await query_handler.main();
    });
  });
}
