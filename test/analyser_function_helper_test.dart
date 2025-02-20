import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/analyser_function_helper.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodyAnalyserFunctionHelper', () {
    final RhapsodyAnalyserFunctionHelper analyser =
        RhapsodyAnalyserFunctionHelper(options: fixtureMockOptions);
    test('should parse a function with a single variabled', () {
      // "func1(env:variable1)"
      final t = MockTokenCreator();
      final List<RhapsodyToken> func = [
        t.token("func1", TokenTypes.identifier),
        t.token("(", TokenTypes.lparen),
        t.token("env", TokenTypes.identifier),
        t.token(":", TokenTypes.colon),
        t.token("variable1", TokenTypes.identifier),
        t.token(")", TokenTypes.rparen),
      ];
      final analyzed = analyser.parseFunctionCall(RhapsodyTokenStream(func));
      expect(analyzed.toString(), equals(''));
    });
  });
}
