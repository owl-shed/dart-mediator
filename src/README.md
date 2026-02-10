A package that implements the architectural mediator pattern, with CQRS
support. \
*(This package has nothing to do with owls, except that it was made by one).*

## Features

- CQRS *(command/query request separation)* support.

## Getting started

- Install the package in your preferred way.
- Implement some commands and queries.
- Register them with the mediator.

## Usage

A simple example of how to use the mediator class.

```dart
void main() async {
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
```

Check out the other examples for more in-depth explanations.

## Additional information

This package is maintained over at
[github.com/owl-shed/dart-mediator](https://github.com/owl-shed/dart-mediator),
I probably won't accept code PRs but who knows, if you find an issue then let
me know.
