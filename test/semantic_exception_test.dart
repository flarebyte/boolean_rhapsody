import 'package:boolean_rhapsody/boolean_rhapsody.dart';
import 'package:test/test.dart';

void main() {
  test('SemanticException toString contains message and token position', () {
    final token = RhapsodyToken(
      text: 'foo',
      type: TokenTypes.identifier,
      startIndex: 7,
      endIndex: 9,
      startPosition: RhapsodyPosition(row: 1, column: 1),
      endPosition: RhapsodyPosition(row: 1, column: 3),
    );
    final ex = SemanticException('unexpected token', token);
    final s = ex.toString();
    expect(s, contains('SemanticException'));
    expect(s, contains('unexpected token'));
    expect(s, contains("token 'foo'"));
    expect(s, contains('index 7'));
  });

  test('SemanticException can be thrown and caught', () {
    final token = RhapsodyToken(
      text: 'bar',
      type: TokenTypes.identifier,
      startIndex: 42,
      endIndex: 45,
      startPosition: RhapsodyPosition(row: 3, column: 2),
      endPosition: RhapsodyPosition(row: 3, column: 5),
    );

    try {
      throw SemanticException('boom', token);
    } catch (e) {
      expect(e, isA<SemanticException>());
      expect(e.toString(), contains("token 'bar'"));
    }
  });
}

