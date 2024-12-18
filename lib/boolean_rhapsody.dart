/// This module enables the evaluation of complex boolean expressions by combining predefined functions, logical operators (and, or, not),
/// and parentheses for grouping. It supports referencing previously defined rules, allowing modular and reusable logic.
/// Functions take a list of variable names, evaluate conditions based on a provided context, and return a boolean.
/// The grammar prioritizes clarity and ensures strict validation of syntax, variable existence, and type compatibility for robust execution.
///
/// This module defines a system for evaluating boolean logic expressions using a combination of:
/// - Predefined boolean functions applied to variables.
/// - Logical operators (`and`, `or`, `not`).
/// - Parentheses for grouping and precedence.
/// - References to previously defined rules.
///
/// ### Grammar:
/// - A **function call** evaluates a specific condition using one or more variables:
///   Example: `func1(a)`, `func2(b, c)`
///
/// - A **rule reference** allows using the result of a previously defined rule:
///   Example: `rule1`, `rule42`
///
/// - **Logical operators** combine expressions:
///   - `and`: Both expressions must be true.
///     Example: `func1(a) and func2(b)`
///   - `or`: At least one expression must be true.
///     Example: `rule1 or func1(a)`
///   - `not`: Negates the truth value of an expression.
///     Example: `not func1(a)`
///
/// - **Parentheses** control grouping and precedence:
///   Example: `(func1(a) or func2(b)) and not rule42`
///
/// ### Operator Precedence:
/// 1. `not` (highest precedence)
/// 2. `and`
/// 3. `or` (lowest precedence)
/// Parentheses override this precedence.
///
/// ### Examples of Valid Expressions:
/// - `rule1 = func1(a)`
/// - `rule2 = func1(a) or func2(b)`
/// - `rule3 = not func1(a)`
/// - `rule4 = (func1(a) or func2(b)) and rule2`
/// - `rule5 = func3(c, d) and (not rule1 or func4(e))`
///
/// ### Supported Boolean Functions (Examples):
/// - `isEmptyString(vars)`
/// - `hasNonWhitespaceChar(vars)`
/// - `startsWith(vars)`
/// - `isNumberGreaterThan(vars)`
///
/// Functions must accept a list of variable names and return a boolean. Variables are retrieved
/// from a context map passed during evaluation, and functions are responsible for validation
/// (e.g., checking if variables are defined or of the correct type).
///
/// ### Constraints:
/// - All function calls and rule references must be valid and defined.
/// - Variables must exist in the evaluation context.
/// - Unbalanced parentheses or invalid syntax will result in errors.
///
/// This module allows for expressive and modular boolean logic that integrates with a dynamic context.
library;

export 'src/rule_evaluator.dart';

// TODO: Export any libraries intended for clients of this package.
