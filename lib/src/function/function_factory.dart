import 'package:boolean_rhapsody/src/comparator/set_comparator.dart';
import 'package:boolean_rhapsody/src/function/set_function.dart';
import 'package:boolean_rhapsody/src/comparator/string_comparator.dart';

import '../comparator/date_time_comparator.dart';
import 'date_time_function.dart';
import 'list_size_function.dart';
import '../comparator/number_comparator.dart';
import 'number_function.dart';
import 'rule_function.dart';
import 'string_function.dart';

/// Factory for boolean rhapsody functions.
///
/// Centralizes construction of built‑in predicates (string/number/date/list/set)
/// so the parser can resolve a function name to an executable implementation.
///
/// Developer guidance:
/// - Parameters are reference keys (`v:` variables or `c:` constants) unless a
///   function explicitly documents otherwise. The concrete functions validate
///   arity and prefixes at construction.
/// - Function names are stable API; prefer adding new names instead of changing
///   semantics of existing ones.
/// - To introduce custom functions without forking, implement
///   [BooleanRhapsodyFunctionBaseFactory] and register it via
///   [BooleanRhapsodyFunctionRegistry]; your factory can either wrap or replace
///   the default behavior.
/// - Use the comparators in `src/comparator/*` to keep comparison semantics
///   consistent across functions.
class BooleanRhapsodyFunctionFactory {
  /// Creates a [BooleanRhapsodyFunction] instance corresponding to the given [name].
  ///
  /// The [name] parameter specifies the type of Boolean function to create.
  /// The [params] list contains references or parameters required by the specific function.
  ///
  /// Supported [name] values include:
  ///
  /// - **String checks**:
  ///   - `'is_absent'`, `'is_present'`, `'is_empty_string'`, `'is_trimmable_string'`,
  ///     `'is_complex_unicode'`, `'is_simple_unicode'`, `'is_allowed_chars'`,
  ///     `'is_multiple_lines'`, `'is_single_line'`.
  ///   - String comparison operations: `'contains_substring'`, `'starts_with_prefix'`,
  ///     `'ends_with_suffix'`, `'string_equals'`.
  ///
  /// - **Number comparisons**:
  ///   - `'number_equals'`, `'number_not_equals'`, `'number_greater_than'`,
  ///     `'number_greater_than_equals'`, `'number_less_than'`, `'number_less_than_equals'`.
  ///
  /// - **Date-time comparisons**:
  ///   - `'date_time_equals'`, `'date_time_not_equals'`, `'date_time_greater_than'`,
  ///     `'date_time_greater_than_equals'`, `'date_time_less_than'`,
  ///     `'date_time_less_than_equals'`.
  ///
  /// - **List size checks**:
  ///   - `'list_size_equals'`, `'list_size_not_equals'`, `'list_size_greater_than'`,
  ///     `'list_size_greater_than_equals'`, `'list_size_less_than'`,
  ///     `'list_size_less_than_equals'`.
  ///
  /// - **Set operations**:
  ///   - `'set_equals'`, `'is_subset_of'`, `'is_superset_of'`, `'is_disjoint'`.
  ///
  /// Throws if the [name] is unknown or the target implementation rejects [params].
  ///
  /// Example usage:
  /// ```dart
  /// final function = BooleanRhapsodyFunctionFactory.create(
  ///   'is_present',
  ///   ['param1', 'param2'],
  /// );
  /// ```
  /// Returns a concrete implementation of [BooleanRhapsodyFunction].
  static BooleanRhapsodyFunction create(String name, List<String> params) {
    switch (name) {
      case 'is_absent':
        return IsAbsentRhapsodyFunction(refs: params);
      case 'is_present':
        return IsPresentRhapsodyFunction(refs: params);
      case 'is_empty_string':
        return IsEmptyStringRhapsodyFunction(refs: params);
      case 'is_trimmable_string':
        return IsTrimmableStringRhapsodyFunction(refs: params);
      case 'is_complex_unicode':
        return IsComplexUnicodeRhapsodyFunction(refs: params);
      case 'is_simple_unicode':
        return IsSimpleUnicodeRhapsodyFunction(refs: params);
      case 'is_allowed_chars':
        return IsAllowedCharsFunction(refs: params);
      case 'is_multiple_lines':
        return IsMultipleLinesRhapsodyFunction(refs: params);
      case 'is_single_line':
        return IsSingleLineRhapsodyFunction(refs: params);
      case 'is_numeric':
        return IsNumericRhapsodyFunction(refs: params);
      case 'is_integer':
        return IsIntegerRhapsodyFunction(refs: params);
      case 'is_date_time':
        return IsDateTimeRhapsodyFunction(refs: params);
      case 'is_url':
        return IsUrlRhapsodyFunction(refs: params);

      // String comparison functions
      case 'contains_substring':
        return CheckStringRhapsodyFunction(
          refs: params,
          stringComparator: RhapsodyStringComparators.contains,
        );
      case 'starts_with_prefix':
        return CheckStringRhapsodyFunction(
          refs: params,
          stringComparator: RhapsodyStringComparators.startsWith,
        );
      case 'ends_with_suffix':
        return CheckStringRhapsodyFunction(
          refs: params,
          stringComparator: RhapsodyStringComparators.endsWith,
        );
      case 'string_equals':
        return CheckStringRhapsodyFunction(
          refs: params,
          stringComparator: RhapsodyStringComparators.equals,
        );

      // Number comparison functions
      case 'number_equals':
        return NumberRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.equalTo,
          refs: params,
        );
      case 'number_not_equals':
        return NumberRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.notEqualTo,
          refs: params,
        );
      case 'number_greater_than':
        return NumberRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.greaterThan,
          refs: params,
        );
      case 'number_greater_than_equals':
        return NumberRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.greaterThanOrEqual,
          refs: params,
        );
      case 'number_less_than':
        return NumberRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.lessThan,
          refs: params,
        );
      case 'number_less_than_equals':
        return NumberRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.lessThanOrEqual,
          refs: params,
        );

      // Date-time comparison functions
      case 'date_time_equals':
        return DateTimeRhapsodyFunction(
          dateTimeComparator: RhapsodyDateTimeComparators.equalTo,
          refs: params,
        );
      case 'date_time_not_equals':
        return DateTimeRhapsodyFunction(
          dateTimeComparator: RhapsodyDateTimeComparators.notEqualTo,
          refs: params,
        );
      case 'date_time_greater_than':
        return DateTimeRhapsodyFunction(
          dateTimeComparator: RhapsodyDateTimeComparators.greaterThan,
          refs: params,
        );
      case 'date_time_greater_than_equals':
        return DateTimeRhapsodyFunction(
          dateTimeComparator: RhapsodyDateTimeComparators.greaterThanOrEqual,
          refs: params,
        );
      case 'date_time_less_than':
        return DateTimeRhapsodyFunction(
          dateTimeComparator: RhapsodyDateTimeComparators.lessThan,
          refs: params,
        );
      case 'date_time_less_than_equals':
        return DateTimeRhapsodyFunction(
          dateTimeComparator: RhapsodyDateTimeComparators.lessThanOrEqual,
          refs: params,
        );

      // List size comparison functions
      case 'list_size_equals':
        return ListSizeRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.equalTo,
          refs: params,
        );
      case 'list_size_not_equals':
        return ListSizeRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.notEqualTo,
          refs: params,
        );
      case 'list_size_greater_than':
        return ListSizeRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.greaterThan,
          refs: params,
        );
      case 'list_size_greater_than_equals':
        return ListSizeRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.greaterThanOrEqual,
          refs: params,
        );
      case 'list_size_less_than':
        return ListSizeRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.lessThan,
          refs: params,
        );
      case 'list_size_less_than_equals':
        return ListSizeRhapsodyFunction(
          numberComparator: RhapsodyNumberComparators.lessThanOrEqual,
          refs: params,
        );

      // Set comparison functions
      case 'set_equals':
        return SetRhapsodyFunction(
          setComparator: RhapsodySetComparators.equals,
          refs: params,
        );
      case 'is_subset_of':
        return SetRhapsodyFunction(
          setComparator: RhapsodySetComparators.isSubset,
          refs: params,
        );
      case 'is_superset_of':
        return SetRhapsodyFunction(
          setComparator: RhapsodySetComparators.isSuperset,
          refs: params,
        );
      case 'is_disjoint':
        return SetRhapsodyFunction(
          setComparator: RhapsodySetComparators.isDisjoint,
          refs: params,
        );

      // Unknown function name
      default:
        throw Exception("The boolean function '$name' is unknown");
    }
  }
}

/// Pluggable factory contract for creating functions.
///
/// Implement to extend/override the set of available functions, then register
/// it with [BooleanRhapsodyFunctionRegistry].
abstract class BooleanRhapsodyFunctionBaseFactory {
  /// Creates an instance of [BooleanRhapsodyFunction] based on the given [name] and [params].
  ///
  /// - [name]: The identifier for the Boolean function to create.
  /// - [params]: A list of parameters required for the function.
  ///
  /// Returns the corresponding [BooleanRhapsodyFunction] implementation.
  ///
  /// Implementations should throw an [Exception] if the [name] is not recognized.
  BooleanRhapsodyFunction create(String name, List<String> params);
}

/// Default factory that delegates to [BooleanRhapsodyFunctionFactory].
class BooleanRhapsodyFunctionRegisterableFactory
    extends BooleanRhapsodyFunctionBaseFactory {
  /// Creates a [BooleanRhapsodyFunction] by delegating to [BooleanRhapsodyFunctionFactory].
  ///
  /// Example:
  /// ```dart
  /// final factory = BooleanRhapsodyFunctionRegisterableFactory();
  /// final function = factory.create('is_present', ['param1']);
  /// ```
  @override
  BooleanRhapsodyFunction create(String name, List<String> params) {
    return BooleanRhapsodyFunctionFactory.create(name, params);
  }
}

/// Registry holding the current function factory.
///
/// Allows swapping the implementation at runtime (useful for tests or
/// host‑specific extensions).
class BooleanRhapsodyFunctionRegistry {
  /// The currently registered factory used to create Boolean functions.
  late BooleanRhapsodyFunctionBaseFactory _factory;

  /// Create a registry with an optional custom [factory].
  BooleanRhapsodyFunctionRegistry({
    BooleanRhapsodyFunctionBaseFactory? factory,
  }) : _factory = factory ?? BooleanRhapsodyFunctionRegisterableFactory();

  /// Register a new [factory] to create [BooleanRhapsodyFunction] instances.
  ///
  /// Example:
  /// ```dart
  /// final registry = BooleanRhapsodyFunctionRegistry();
  /// registry.registerFactory(MyCustomFunctionFactory());
  /// ```
  void registerFactory(BooleanRhapsodyFunctionBaseFactory factory) {
    _factory = factory;
  }

  /// Create a [BooleanRhapsodyFunction] using the registered factory.
  ///
  /// Throws if the [name] is unknown.
  ///
  /// Example:
  /// ```dart
  /// final registry = BooleanRhapsodyFunctionRegistry();
  /// final function = registry.create('is_numeric', ['field1']);
  /// ```
  BooleanRhapsodyFunction create(String name, List<String> params) {
    return _factory.create(name, params);
  }
}

/// Canonical list of built‑in function names.
///
/// Use this for validation, autocomplete, and documentation.
const List<String> rhapsodyFunctionNames = [
  // Basic checks
  'is_absent',
  'is_present',
  'is_empty_string',
  'is_trimmable_string',
  'is_complex_unicode',
  'is_simple_unicode',
  'is_allowed_chars',
  'is_multiple_lines',
  'is_single_line',
  'is_numeric',
  'is_integer',
  'is_date_time',
  'is_url',

  // String comparison functions
  'contains_substring',
  'starts_with_prefix',
  'ends_with_suffix',
  'string_equals',

  // Number comparison functions
  'number_equals',
  'number_not_equals',
  'number_greater_than',
  'number_greater_than_equals',
  'number_less_than',
  'number_less_than_equals',

  // Date-time comparison functions
  'date_time_equals',
  'date_time_not_equals',
  'date_time_greater_than',
  'date_time_greater_than_equals',
  'date_time_less_than',
  'date_time_less_than_equals',

  // List size comparison functions
  'list_size_equals',
  'list_size_not_equals',
  'list_size_greater_than',
  'list_size_greater_than_equals',
  'list_size_less_than',
  'list_size_less_than_equals',

  // Set comparison functions
  'set_equals',
  'is_subset_of',
  'is_superset_of',
  'is_disjoint',
];
