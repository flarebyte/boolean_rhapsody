import 'package:boolean_rhapsody/src/set_comparator.dart';
import 'package:boolean_rhapsody/src/set_function.dart';
import 'package:boolean_rhapsody/src/string_comparator.dart';

import 'date_time_comparator.dart';
import 'date_time_function.dart';
import 'list_size_function.dart';
import 'number_comparator.dart';
import 'number_function.dart';
import 'rule_function.dart';
import 'string_function.dart';

/// A factory class that creates instances of [BooleanRhapsodyFunction] based
/// on the provided [name] and [params].
///
/// This class centralizes the creation of Boolean evaluation functions,
/// supporting various checks such as string, numeric, date-time, list, and set
/// operations.
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
  /// Throws an [Exception] if the [name] does not match any known Boolean function.
  ///
  /// Example usage:
  /// ```dart
  /// final function = BooleanRhapsodyFunctionFactory.create(
  ///   'is_present',
  ///   ['param1', 'param2'],
  /// );
  /// ```
  ///
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

/// An abstract base class defining the contract for factories responsible
/// for creating [BooleanRhapsodyFunction] instances.
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

/// A default implementation of [BooleanRhapsodyFunctionBaseFactory] that
/// delegates creation to [BooleanRhapsodyFunctionFactory].
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

/// A registry responsible for managing a [BooleanRhapsodyFunctionBaseFactory]
/// and providing access to create [BooleanRhapsodyFunction] instances.
///
/// This class allows for dynamic replacement of the factory at runtime,
/// enabling extensibility with custom function factories.
class BooleanRhapsodyFunctionRegistry {
  /// The currently registered factory used to create Boolean functions.
  ///
  /// By default, this should be set to an instance of
  /// [BooleanRhapsodyFunctionRegisterableFactory].
  late BooleanRhapsodyFunctionBaseFactory _factory;

  /// Creates an instance of [BooleanRhapsodyFunctionRegistry] with an optional custom [factory].
  ///
  /// If [factory] is not provided, a default [BooleanRhapsodyFunctionRegisterableFactory]
  /// is used.
  BooleanRhapsodyFunctionRegistry({
    BooleanRhapsodyFunctionBaseFactory? factory,
  }) : _factory = factory ?? BooleanRhapsodyFunctionRegisterableFactory();

  /// Registers a new [factory] for creating [BooleanRhapsodyFunction] instances.
  ///
  /// This allows dynamic replacement of the factory at runtime, enabling support
  /// for custom Boolean functions.
  ///
  /// Example:
  /// ```dart
  /// final registry = BooleanRhapsodyFunctionRegistry();
  /// registry.registerFactory(MyCustomFunctionFactory());
  /// ```
  void registerFactory(BooleanRhapsodyFunctionBaseFactory factory) {
    _factory = factory;
  }

  /// Creates a [BooleanRhapsodyFunction] using the currently registered factory.
  ///
  /// - [name]: The identifier for the Boolean function to create.
  /// - [params]: A list of parameters required for the function.
  ///
  /// Throws an [Exception] if the [name] is not supported by the current factory.
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
