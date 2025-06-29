/// Represents a key-value data store that supports prefix validation
/// and optional typed value decoding.
abstract class RhapsodyBaseDataStore {
  /// Retrieves the string value associated with [key], or `null` if not found.
  String? get(String key);

  ///The value for the given key, or null if key is not in the map.
  String? operator [](String key);

  /// Associates the [value] with the given [key], replacing any existing value.
  void set(String key, String value);

  /// Removes the entry associated with [key], if it exists.
  void remove(String key);

  /// Clear the data store
  void clear();

  /// Add multiple values at once
  void addAll(Map<String, String> other);
}

/// A simple in-memory implementation of [RhapsodyBaseDataStore] using [Map].
class RhapsodyDataStore implements RhapsodyBaseDataStore {
  final Map<String, String> _store = <String, String>{};

  /// {@macro KiwiWatermelonDataStore.get}
  @override
  String? get(String key) => _store[key];

  /// {@macro KiwiWatermelonDataStore.[]}
  @override
  String? operator [](String key) => _store[key];

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

  /// {@macro KiwiWatermelonDataStore.addAll}
  @override
  void addAll(Map<String, String> other) {
    _store.addAll(other);
  }

  @override
  String toString() {
    return 'RhapsodyDataStore{_store: $_store}';
  }
}
