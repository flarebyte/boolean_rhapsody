# boolean\_rhapsody

![Experimental](https://img.shields.io/badge/status-experimental-blue)

> Tune into the truth with Boolean Rhapsody in Dart

A module for evaluating boolean expressions using predefined functions,
logical operators, and references to previously defined rules.

![Hero image for boolean\_rhapsody](doc/boolean_rhapsody.jpeg)

Highlights:

-   Combine predefined boolean functions, logical operators (`and`, `or`,
    `not`), and parentheses to create complex expressions.
-   Supports referencing previously defined rules for modular and reusable
    logic.
-   Ensures strict validation of syntax, variable existence, and type
    compatibility for robust execution.
-   Functions evaluate conditions based on a dynamic context and return
    boolean results.
-   Clear and well-defined grammar prioritizing expressiveness and error
    prevention.

A few examples:

Check if a required environment variable is present:

```dart
is_present(env:flag:green);
```

Validate that a numeric score exceeds a threshold:

```dart
number_greater_than(env:score, config:passing_score);
```

Compare string values for exact match:

```dart
string_equals(env:mode, config:expected_mode);
```

Confirm that a timestamp is before a configured deadline:

```dart
date_time_less_than(env:submission_time, config:deadline);
```

Ensure a minimum number of items in a list:

```dart
list_size_greater_than_equals(env:cart_items, config:min_required);
```

Check if a user's roles include all required permissions:

```dart
is_superset_of(env:user_roles, config:required_roles);
```

Instantiate function registry containing boolean functions like
string\_equals:

```dart
final functionRegistry = BooleanRhapsodyFunctionRegistry();
```

Configure analyser options with allowed prefixes, functions, and a variable
validator:

```dart
final options = RhapsodyAnalyserOptions(
  prefixes: ['env', 'config'],
  functions: rhapsodyFunctionNames,
  variableValidator: (name) => RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$').hasMatch(name),
  functionRegistry: functionRegistry,
);

```

Tokenise rule strings into a list of tokens:

```dart
final tokeniser = RhapsodyTokeniser();
final tokens = tokeniser.parse('rule example = is_present(env:flag);');

```

Perform semantic analysis on parsed tokens:

```dart
final analyser = RhapsodySemanticAnalyser(options);
final analysis = analyser.analyse(tokens);

```

Instantiate interpreter with analysed rule structure:

```dart
final interpreter = RhapsodyInterpreter(analysis);
```

Create evaluation context with variable bindings:

```dart
RhapsodyEvaluationContextBuilder builder =
 RhapsodyEvaluationContextBuilder(prefixes: ['env', 'config']);
 builder.setRefValue('env:state', 'green');
 builder.setRefValue('env:alert', 'panic');
 RhapsodyEvaluationContext context = builder.build();

```

Interpret rules against the provided evaluation context:

```dart
interpreter.interpret(context);
```

Print or inspect rule evaluation results:

```dart
print(context.ruleState.states);
```

## Documentation and links

-   [Code Maintenance :wrench:](MAINTENANCE.md)
-   [Code Of Conduct](CODE_OF_CONDUCT.md)
-   [Contributing :busts\_in\_silhouette: :construction:](CONTRIBUTING.md)
-   [Architectural Decision Records :memo:](DECISIONS.md)
-   [Contributors
    :busts\_in\_silhouette:](https://github.com/flarebyte/boolean_rhapsody/graphs/contributors)
-   [Dependencies](https://github.com/flarebyte/boolean_rhapsody/network/dependencies)
-   [Glossary
    :book:](https://github.com/flarebyte/overview/blob/main/GLOSSARY.md)
-   [Software engineering principles
    :gem:](https://github.com/flarebyte/overview/blob/main/PRINCIPLES.md)
-   [Overview of Flarebyte.com ecosystem
    :factory:](https://github.com/flarebyte/overview)
-   [Dart dependencies](DEPENDENCIES.md)
-   [Internal dependencies](INTERNAL-DEPENDENCIES.md)
-   [Usage](USAGE.md)
-   [Example](example/example.dart)

## Related

-   [form\_validator](https://pub.dev/packages/form_validator)
