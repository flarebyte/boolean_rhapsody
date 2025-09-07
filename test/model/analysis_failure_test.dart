import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:boolean_rhapsody/src/model/analysis_failure.dart';
import 'package:test/test.dart';

void main() {
  test('RhapsodyAnalysisFailure toString includes position and message', () {
    final pos = RhapsodyPosition(row: 2, column: 10);
    final failure = RhapsodyAnalysisFailure(
      position: pos,
      index: 5,
      errorType: 'Syntax',
      message: 'Unexpected token',
      contextCode: 'a b c',
      expected: 'identifier',
      suggestion: 'Check your input',
    );
    final s = failure.toString();
    expect(s, contains('AnalysisFailure'));
    expect(s, contains('position'));
    expect(s, contains('Unexpected token'));
  });
}

