import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

import 'code_fixtures.dart';

void main() {
  group('RhapsodyBooleanExpressionAnalyser', () {
    final RhapsodyBooleanExpressionAnalyser analyser =
        RhapsodyBooleanExpressionAnalyser(
            options: fixtureMockOptions, ruleDefinitions: {});

    test('should evaluate as truthy when comparator condition is satisfied',
        () {
      final analyzed = analyser.analyse(rule23);
      expect(analyzed, null);
    });
  });
}
