import 'package:owl_mediator/mediator.dart';
import 'package:owl_mediator/query.dart';
import 'package:owl_mediator/command.dart';
import 'package:test/test.dart';

class TestQueryHandler<TQuery extends IQuery<TResult>, TResult>
    implements IQueryHandler<TQuery, TResult> {
  final TResult _result;

  TestQueryHandler(this._result);

  @override
  Future<TResult> handle(TQuery request) {
    return Future.value(_result);
  }
}

class TestCommandHandler<TCommand extends ICommand<TResult>, TResult>
    implements ICommandHandler<TCommand, TResult> {
  final TResult _result;

  TestCommandHandler(this._result);

  @override
  Future<TResult> handle(TCommand request) {
    return Future.value(_result);
  }
}

class TestQuery<TResult> implements IQuery<TResult> {}

class TestCommand<TResult> implements ICommand<TResult> {}

// No AAA cause dart makes it annoying at times :(

void main() {
  group("Mediator", () {
    group(".register", () {
      test("Query() throws error if query type is already registered.", () {
        Mediator sut = Mediator();
        TestQueryHandler<TestQuery<int>, int> handler = TestQueryHandler(0);
        sut.registerQuery(handler);

        expect(() => sut.registerQuery(handler), throwsA(isA<StateError>()));
      });

      test("Command() throws error if command type is already registered.", () {
        Mediator sut = Mediator();
        TestCommandHandler<TestCommand<int>, int> handler = TestCommandHandler(
          0,
        );
        sut.registerCommand(handler);

        expect(() => sut.registerCommand(handler), throwsA(isA<StateError>()));
      });
    });

    group(".run", () {
      group("Query()", () {
        test(" throws error if no query handler is registered.", () async {
          Mediator sut = Mediator();

          await expectLater(
            () => sut.runQuery(TestQuery<int>()),
            throwsA(isA<StateError>()),
          );
        });

        test(" returns result.", () async {
          Mediator sut = Mediator();
          int expectedResult = 1;
          TestQueryHandler<TestQuery<int>, int> handler = TestQueryHandler(
            expectedResult,
          );
          sut.registerQuery<TestQuery<int>, int>(handler);

          int result = await sut.runQuery(TestQuery<int>());

          expect(result, equals(expectedResult));
        });
      });

      group("Command()", () {
        test(" throws error if no command handler is registered.", () async {
          Mediator sut = Mediator();

          await expectLater(
            () => sut.runCommand(TestCommand<int>()),
            throwsA(isA<StateError>()),
          );
        });

        test(" returns result.", () async {
          Mediator sut = Mediator();
          int expectedResult = 1;
          TestCommandHandler<TestCommand<int>, int> handler =
              TestCommandHandler(expectedResult);
          sut.registerCommand<TestCommand<int>, int>(handler);

          int result = await sut.runCommand(TestCommand<int>());

          expect(result, equals(expectedResult));
        });
      });
    });
  });
}
