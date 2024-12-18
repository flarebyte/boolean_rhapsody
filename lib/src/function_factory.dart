import 'rule_function.dart';
import 'string_function.dart';

/// A factory class for creating instances of [BooleanRhapsodyFunction]
/// based on a provided function name and parameters.
class BooleanRhapsodyFunctionFactory {
  /// Creates an instance of a [BooleanRhapsodyFunction] based on the given [name]
  /// and [params].
  ///
  /// [name] - The name of the boolean function to create. Supported names:
  ///   - `'is_absent'` - Creates an instance of [IsAbsentRhapsodyFunction].
  ///   - `'is_present'` - Creates an instance of [IsPresentRhapsodyFunction].
  ///   - `'is_empty_string'` - Creates an instance of [IsEmptyStringRhapsodyFunction].
  ///   - `'is_multiple_lines'` - Creates an instance of [IsMultipleLinesRhapsodyFunction].
  ///   - `'is_single_line'` - Creates an instance of [IsSingleLineRhapsodyFunction].
  ///   - `'contains_substring'` - Creates an instance of [ContainsSubstringRhapsodyFunction].
  ///   - `'starts_with_prefix'` - Creates an instance of [StartsWithPrefixRhapsodyFunction].
  ///   - `'ends_with_suffix'` - Creates an instance of [EndsWithSuffixRhapsodyFunction].
  ///   - `'equals'` - Creates an instance of [EqualsRhapsodyFunction].
  ///
  /// [params] - The list of parameter references required by the function. The
  /// specific requirements for this list depend on the function being created.
  ///
  /// Returns:
  /// An instance of the corresponding [BooleanRhapsodyFunction].
  ///
  /// Throws:
  /// - [Exception] if the [name] is not recognized or supported.
  static BooleanRhapsodyFunction create(String name, List<String> params) {
    switch (name) {
      case 'is_absent':
        return IsAbsentRhapsodyFunction(refs: params);
      case 'is_present':
        return IsPresentRhapsodyFunction(refs: params);
      case 'is_empty_string':
        return IsEmptyStringRhapsodyFunction(refs: params);
      case 'is_multiple_lines':
        return IsMultipleLinesRhapsodyFunction(refs: params);
      case 'is_single_line':
        return IsSingleLineRhapsodyFunction(refs: params);
      case 'contains_substring':
        return ContainsSubstringRhapsodyFunction(refs: params);
      case 'starts_with_prefix':
        return StartsWithPrefixRhapsodyFunction(refs: params);
      case 'ends_with_suffix':
        return EndsWithSuffixRhapsodyFunction(refs: params);
      case 'equals':
        return EqualsRhapsodyFunction(refs: params);
      default:
        throw Exception("The boolean function '$name' is unknown");
    }
  }
}
