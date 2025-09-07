import 'package:boolean_rhapsody/src/model/data_store.dart';
import 'package:test/test.dart';

void main() {
  group('RhapsodyDataStore', () {
    test('set/get and operator[] work', () {
      final store = RhapsodyDataStore();
      store.set('a', '1');
      expect(store.get('a'), equals('1'));
      expect(store['a'], equals('1'));
    });

    test('addAll merges entries', () {
      final store = RhapsodyDataStore();
      store.set('a', '1');
      store.addAll({'b': '2', 'c': '3'});
      expect(store.get('a'), equals('1'));
      expect(store.get('b'), equals('2'));
      expect(store.get('c'), equals('3'));
    });

    test('remove deletes key and clear wipes all', () {
      final store = RhapsodyDataStore();
      store.addAll({'a': '1', 'b': '2'});
      store.remove('a');
      expect(store.get('a'), isNull);
      expect(store.get('b'), equals('2'));

      store.clear();
      expect(store.get('b'), isNull);
    });

    test('toString prints inner map', () {
      final store = RhapsodyDataStore();
      store.addAll({'x': 'y'});
      final s = store.toString();
      expect(s, contains('RhapsodyDataStore'));
      expect(s, contains('x'));
      expect(s, contains('y'));
    });
  });
}
