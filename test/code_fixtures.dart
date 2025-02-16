// Example: mock options for RhapsodyParserOptions.
import 'package:boolean_rhapsody/boolean_rhapsody.dart';

final RhapsodyAnalyserOptions fixtureMockOptions = RhapsodyAnalyserOptions(
  prefixes: ['env', 'config'],
  functions: ['func1', 'func2', 'log', 'calc'],
  variableValidator: (String variableName) {
    // A valid variable name must start with a letter and may contain letters and digits.
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$').hasMatch(variableName);
  },
);

// An array of code samples representing a diverse set of valid and invalid code,
// including some examples that span multiple lines.
final List<String> codeSamples = [
  // Valid: A well-formed rule expression in a single line.
  "rule23 = (func1(env:variable1) or func2(config:variable2)) and not rule42;",

  // Valid: A rule expression with extra grouping spanning multiple lines.
  """
  rule1 = func1(env:var) and 
       (func2(config:var2) or not func1(env:otherVar));
  """,

  // Valid: A simple variable reference.
  "env:validVar",

  // Invalid: Variable part starts with digits, which fails the variable validator.
  "config:123invalid",

  // Valid: A line that is just a comment.
  "# This is a standalone comment",

  // Invalid: A function call with a missing closing parenthesis.
  "func1(env:var",

  // Valid: A function call with multiple parameters spanning multiple lines.
  """
  func2(env:var1, config:var2, env:var3)
  """,

  // Invalid: Uses an unknown operator 'xor' which is not supported.
  "rule10 = func1(env:var) xor func2(config:var);",

  // Valid: A rule expression that includes an inline comment.
  "rule42 = (log(env:var)) # inline comment",

  // Valid: A multi-line code sample with a leading comment and multiple rule statements.
  """
   # Leading whitespace before a comment
   rule5 = calc(config:calcVar) and not func1(env:var);
   rule6 = func2(env:anotherVar) or func1(env:yetAnotherVar);
  """
];

class MockTokenCreator {
  int index = 0;
  MockTokenCreator();

  RhapsodyToken token(String text, String type) {
    index = index + 1;
    return RhapsodyToken(
        text: text,
        type: type,
        startIndex: index,
        endIndex: index,
        startPosition: RhapsodyPosition(row: index, column: index),
        endPosition: RhapsodyPosition(row: index, column: index));
  }
}

// "rule rule23 = (func1(env:variable1) or func2(config:variable2)) and not rule42;"
final r23 = MockTokenCreator();
final List<RhapsodyToken> rule23 = [
  r23.token("rule", TokenTypes.identifier),
  r23.token("rule23", TokenTypes.identifier),
  r23.token("=", TokenTypes.equal),
  r23.token("(", TokenTypes.lparen),
  r23.token("func1", TokenTypes.identifier),
  r23.token("(", TokenTypes.lparen),
  r23.token("env", TokenTypes.identifier),
  r23.token(":", TokenTypes.colon),
  r23.token("variable1", TokenTypes.identifier),
  r23.token(")", TokenTypes.rparen),
  r23.token("or", TokenTypes.operatorType),
  r23.token("func2", TokenTypes.identifier),
  r23.token("(", TokenTypes.lparen),
  r23.token("config", TokenTypes.identifier),
  r23.token(":", TokenTypes.colon),
  r23.token("variable2", TokenTypes.identifier),
  r23.token(")", TokenTypes.rparen),
  r23.token(")", TokenTypes.rparen),
  r23.token("and", TokenTypes.operatorType),
  r23.token("not", TokenTypes.operatorType),
  r23.token("rule42", TokenTypes.identifier),
  r23.token(";", TokenTypes.semicolon),
];

// rule rule25 = func1(env:variable1, env:variable2, env:variable3) and (func2(env:variable3) or calc(config:config1));
final r25 = MockTokenCreator();
final List<RhapsodyToken> rule25 = [
  r25.token("rule", TokenTypes.identifier),
  r25.token("rule25", TokenTypes.identifier),
  r25.token("=", TokenTypes.equal),
  r25.token("func1", TokenTypes.identifier),
  r25.token("(", TokenTypes.lparen),
  r25.token("env", TokenTypes.identifier),
  r25.token(":", TokenTypes.colon),
  r25.token("variable1", TokenTypes.identifier),
  r25.token(",", TokenTypes.comma),
  r25.token("env", TokenTypes.identifier),
  r25.token(":", TokenTypes.colon),
  r25.token("variable2", TokenTypes.identifier),
  r25.token(",", TokenTypes.comma),
  r25.token("env", TokenTypes.identifier),
  r25.token(":", TokenTypes.colon),
  r25.token("variable3", TokenTypes.identifier),
  r25.token(")", TokenTypes.rparen),
  r25.token("and", TokenTypes.operatorType),
  r25.token("(", TokenTypes.lparen),
  r25.token("func2", TokenTypes.identifier),
  r25.token("(", TokenTypes.lparen),
  r25.token("env", TokenTypes.identifier),
  r25.token(":", TokenTypes.colon),
  r25.token("variable3", TokenTypes.identifier),
  r25.token(")", TokenTypes.rparen),
  r25.token("or", TokenTypes.operatorType),
  r25.token("calc", TokenTypes.identifier),
  r25.token("(", TokenTypes.lparen),
  r25.token("config", TokenTypes.identifier),
  r25.token(":", TokenTypes.colon),
  r25.token("config1", TokenTypes.identifier),
  r25.token(")", TokenTypes.rparen),
  r25.token(")", TokenTypes.rparen),
  r25.token(";", TokenTypes.semicolon),
];

// rule rule27 = rule21 or rule28 and not (rule7 or rule8);
final r27 = MockTokenCreator();
final List<RhapsodyToken> rule27 = [
  r27.token("rule", TokenTypes.identifier),
  r27.token("rule27", TokenTypes.identifier),
  r27.token("=", TokenTypes.equal),
  r27.token("rule21", TokenTypes.identifier),
  r27.token("or", TokenTypes.operatorType),
  r27.token("rule28", TokenTypes.identifier),
  r27.token("and", TokenTypes.operatorType),
  r27.token("not", TokenTypes.operatorType),
  r27.token("(", TokenTypes.lparen),
  r27.token("rule7", TokenTypes.identifier),
  r27.token("or", TokenTypes.operatorType),
  r27.token("rule8", TokenTypes.identifier),
  r27.token(")", TokenTypes.rparen),
  r27.token(";", TokenTypes.semicolon),
];
