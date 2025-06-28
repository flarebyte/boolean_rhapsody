/// Represents a key-value data store that supports prefix validation
/// and optional typed value decoding.
abstract class KiwiWatermelonDataStore {
  /// Retrieves the string value associated with [key], or `null` if not found.
  String? get(String key);

  /// Associates the [value] with the given [key], replacing any existing value.
  void set(String key, String value);

  /// Removes the entry associated with [key], if it exists.
  void remove(String key);

  /// Clear the data store
  void clear();
}

/// A simple in-memory implementation of [KiwiWatermelonDataStore] using [Map].
class RhapsodyDataStore implements KiwiWatermelonDataStore {
  final Map<String, String> _store = <String, String>{};

  /// {@macro KiwiWatermelonDataStore.get}
  @override
  String? get(String key) => _store[key];

  /// {@macro KiwiWatermelonDataStore.set}
  @override
  void set(String key, String value) {
    _store[key] = value;
  }

  /// {@macro KiwiWatermelonDataStore.remove}
  @override
  void remove(String key) {
    _store.remove(key);
  }

  /// {@macro KiwiWatermelonDataStore.clear}
  @override
  void clear() {
    _store.clear();
  }
}


