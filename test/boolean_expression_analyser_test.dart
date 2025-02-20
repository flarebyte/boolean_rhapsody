import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodyBooleanExpressionAnalyser', () {
    test('should evaluate as truthy when comparator condition is satisfied',
        () {
      final Map<String, RhapsodyBooleanExpression> ruleDefinitions = {};
      final RhapsodyBooleanExpressionAnalyser analyser =
          RhapsodyBooleanExpressionAnalyser(
              options: fixtureMockOptions, ruleDefinitions: ruleDefinitions);
      final analyzed = analyser.analyse(rule23);
      expect(analyzed.toString(), equals(''));
    });
  });
}
