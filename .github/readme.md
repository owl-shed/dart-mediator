# Dart mediator

<!-- Do not put the link/image nested tags on new lines as that will count the links as having whitespace which changes the rendering -->

<p align=center>
  <a title="A link to the latest version of the main pub.dev package for the project." href="https://pub.dev/packages/owl_mediator"><img alt="A status badge for the latest version of the main pub.dev package for the project." src="https://img.shields.io/pub/v/owl_mediator?logo=dart&logoColor=%230175C2&labelColor=%23d7d7d7"></a>
  <a title="A link to the score rating of the latest version of the main pub.dev package for the project." href="https://pub.dev/packages/owl_mediator/score"><img alt="A status badge for the score rating of the latest version of the main pub.dev package for the project." src="https://img.shields.io/pub/points/owl_mediator?logo=dart&logoColor=%230175C2&labelColor=%23d7d7d7&color=0175C2"></a>
  <a title="A link to the likes for the latest version of the main pub.dev package for the project." href="https://pub.dev/packages/owl_mediator/score"><img alt="A status badge for the likes for the latest version of the main pub.dev package for the project." src="https://img.shields.io/pub/likes/owl_mediator?logo=dart&logoColor=%230175C2&labelColor=%23d7d7d7"></a>
</p>

<p align="center"> <!-- Organisation -->
  <a title="A link to the OwlDomain Discord server." href="https://discord.gg/eXXnjTUPV2"><img alt="Status badge for the OwlDomain discord server." src="https://img.shields.io/discord/1411024983550853162?style=social&logo=discord&label=discord&link=https%3A%2F%2Fdiscord.gg%eXXnjTUPV2"></a>
</p>

---

This is a dart implementation of the architectural mediator pattern, there are
a few like it, but this one is mine.


## Currently supported

- CQRS *(command/query request separation)*. You can create command and queries,
  and then handle them centrally through the mediator.


## Planned

- Events.
- Analysers for:
  - Checking that commands/queries have matching handlers.
  - Checking that the ran command/query has a registered handler.
  - Checking that handlers aren't registered multiple times.
- Code generators for:
  - Automatically registering commands/queries.
  - Automatically generating mediator extension methods for your handlers.


## Usage

The usage is simple, but look in the [examples folder](../src/example/) in the
package for more in-depth explanations.

The `Mediator` class acts as the main entry point for this package, it doesn't
have any complex dependencies, and in order to use it you just have to create
an instance of it:
```dart
void main() async {
  // Create the mediator.
  Mediator mediator = Mediator();

  // Register your handler.
  mediator.registerCommand(ConvertToStringCommandHandler());

  // Run your command.
  String result1 = await mediator.runCommand(ConvertToStringCommand(123));

  // Or if you implemented the recommended extension method.
  String result2 = await mediator.convertToString(123);
}
```


## Development

This package is being developed on the `develop` branch, the *(default)* `main`
branch will only be updated either when it's absolutely necessary, or when
there's a new release.
