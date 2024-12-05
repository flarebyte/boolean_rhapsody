# Architecture decision records

An [architecture
decision](https://cloud.google.com/architecture/architecture-decision-records)
is a software design choice that evaluates:

-   a functional requirement (features).
-   a non-functional requirement (technologies, methodologies, libraries).

The purpose is to understand the reasons behind the current architecture, so
they can be carried-on or re-visited in the future.

## Idea

### Problem Description:

The objective is to create a Dart library capable of evaluating boolean
expressions defined in a Domain-Specific Language (DSL). The inputs are a map
of variables (string key-value pairs) that represent the current evaluation
context. The boolean rules, expressed in the DSL, combine variables,
functions, and rules into expressions using boolean operators and precedence
control via parentheses.

### Use Cases:

1.  **Basic Boolean Evaluation**:

    -   Input: Map with `{ "abc123": true }`
    -   Rule: `[v:abc123]`
    -   Output: `true`

2.  **Combining Rules**:

    -   Input: Map with `{ "abc123": true, "hgty89": false }`
    -   Rule: `[v:abc123, f:and, v:hgty89]`
    -   Output: `false`

3.  **Nested Rules**:

    -   Input: Map with `{ "abc123": true, "rule34": false }`
    -   Rule: `[r:rule34, f:or, v:abc123]`
    -   Output: `true`

4.  **Parentheses for Precedence**:

    -   Input: Map with `{ "abc123": true, "hgty89": false, "rule34": true }`
    -   Rule: `[r:rule34, f:and, (, v:hgty89, f:or, v:abc123, )]`
    -   Output: `true`

5.  **Variable Comparisons**:

    -   Input: Map with `{ "gdj78": 10, "hkahs78": 5 }`
    -   Rule: `[f:greaterThan, v:gdj78, v:hkahs78]`
    -   Output: `true`

6.  **String Comparisons**:

    -   Input: Map with `{ "term": "hello", "text": "hello world" }`
    -   Rule: `[f:contains, v:term, v:text]`
    -   Output: `true`

7.  **Constants as Variables**:
    -   Input: Map with `{ "threshold": 10 }`
    -   Rule: `[f:greaterThan, v:threshold, v:5]`
    -   Output: `true`

### Edge Cases:

1.  **Undefined Variables**:

    -   Input: Map with `{ "abc123": true }`
    -   Rule: `[v:undefinedVar]`
    -   Expected Behavior: Validation error.

2.  **Unbalanced Parentheses**:

    -   Rule: `[r:rule34, (, v:abc123, f:or, r:rule35]`
    -   Expected Behavior: Validation error.

3.  **Invalid Tokens**:

    -   Rule: `[x:invalidToken, v:abc123]`
    -   Expected Behavior: Validation error.

4.  **Type Mismatches**:

    -   Input: Map with `{ "abc123": 10 }`
    -   Rule: `[f:contains, v:abc123, v:text]`
    -   Expected Behavior: Validation error due to type incompatibility.

5.  **Empty Rules**:

    -   Rule: `[]`
    -   Expected Behavior: Validation error.

6.  **Recursive Rules**:
    -   Rule: `[r:ruleA, r:ruleA]`
    -   Expected Behavior: Validation error or loop prevention.

### DSL Specification:

1.  **Tokens**:

    -   `v:`: Represents a variable. Must match a key in the input map.
    -   `r:`: Represents a rule. Should reference another rule in the system.
    -   `f:`: Represents a function. Includes logical operators (`and`, `or`,
        `not`), comparison functions (`greaterThan`, `contains`), and custom
        functions.

2.  **Operators**:

    -   `f:and`, `f:or`, `f:not`: Logical operators.
    -   `f:greaterThan`, `f:lessThan`, `f:equals`: Numeric comparisons.
    -   `f:contains`: String containment check.

3.  **Parentheses**:

    -   Used for grouping and precedence, represented as `(` and `)`.

4.  **Constants**:

    -   Treated as variables, allowing consistent token validation.

5.  **Validation Rules**:
    -   Tokens must adhere to one of the predefined prefixes (`v:`, `r:`,
        `f:`).
    -   Parentheses must be balanced.
    -   Variables and rules must be defined.
    -   Type compatibility must be enforced during evaluation.

### Scope and Limitations:

1.  **Scope**:

    -   Evaluate boolean rules with a mix of logical operators and custom
        functions.
    -   Handle string and numeric comparisons.
    -   Ensure clear precedence with parentheses.

2.  **Out of Scope**:

    -   Free text evaluation outside the defined variable map.
    -   Advanced data structures like arrays or objects.
    -   Implicit type conversions (e.g., comparing strings to numbers).
    -   Complex dependency graphs with cyclic references.

3.  **Examples of Out of Scope**:
    -   Rule: `[v:abc123, f:contains, "freeText"]` → Invalid.
    -   Rule: `[v:abc123, f:and, { complex: "data" }]` → Invalid.

## Specification Refinement

#### Function Names and Behaviors:

1.  **Undefined Variable Check**

    -   **Name**: `isUndefined`
    -   **Description**: Returns `true` if the variable is not defined in the
        input map.

2.  **Empty String Check**

    -   **Name**: `isEmptyString`
    -   **Description**: Returns `true` if the variable is an empty string
        (`""`).

3.  **Non-Whitespace String Check**

    -   **Name**: `hasNonWhitespaceChar`
    -   **Description**: Returns `true` if the variable is a string with at
        least one non-whitespace character.

4.  **Whitespace-Only String Check**

    -   **Name**: `isWhitespace`
    -   **Description**: Returns `true` if the variable is a string containing
        only whitespace characters.

5.  **Multiple Lines Check**

    -   **Name**: `isMultiline`
    -   **Description**: Returns `true` if the variable contains multiple lines
        (e.g., contains `\n`).

6.  **Single Line Check**

    -   **Name**: `isSingleLine`
    -   **Description**: Returns `true` if the variable contains only a single
        line.

7.  **Substring Containment Check**

    -   **Name**: `containsTerm`
    -   **Description**: Returns `true` if the term (variable) is contained in
        the text (variable).

8.  **Prefix Check**

    -   **Name**: `startsWith`
    -   **Description**: Returns `true` if the text (variable) starts with the
        prefix (variable).

9.  **Suffix Check**

    -   **Name**: `endsWith`
    -   **Description**: Returns `true` if the text (variable) ends with the
        suffix (variable).

10. **Equality Check**

    -   **Name**: `equals`
    -   **Description**: Returns `true` if the text (variable) equals the other
        text (variable).

11. **Keyword Containment Check**

    -   **Name**: `containsAnyKeywords`
    -   **Description**: Returns `true` if the text (variable) contains any
        keywords from the keyword list (variable). An optional separator
        (variable) determines keyword splitting; defaults to line breaks
        (`\n`).

12. **Numeric Comparisons**:

    -   **Name**: `isNumberGreaterThan`
        -   **Description**: Returns `true` if the numeric value of text (variable)
            is greater than the threshold (variable).
    -   **Name**: `isNumberLessThan`
        -   **Description**: Returns `true` if the numeric value of text (variable)
            is less than the threshold (variable).
    -   **Name**: `isNumberEqualTo`
        -   **Description**: Returns `true` if the numeric value of text (variable)
            equals the threshold (variable).

13. **Length Comparisons**:
    -   **Name**: `isLengthEqualTo`
        -   **Description**: Returns `true` if the length of the text (variable)
            equals the threshold (variable).
    -   **Name**: `isLengthLessThan`
        -   **Description**: Returns `true` if the length of the text (variable) is
            less than the threshold (variable).
    -   **Name**: `isLengthGreaterThan`
        -   **Description**: Returns `true` if the length of the text (variable) is
            greater than the threshold (variable).

## Specification: Grammar for Boolean Rule Expressions

### Grammar Components:

1.  **Primitive Elements**:

    -   **Function Call**: A boolean function applied to a list of variables.
        -   **Syntax**: `<functionName>(<var1>, <var2>, ...)`
        -   **Example**: `func1(a)`, `func2(b, c)`
    -   **Rule Reference**: A reference to a previously defined rule.
        -   **Syntax**: `<ruleName>`
        -   **Example**: `rule42`

2.  **Logical Operators**:

    -   **AND**: Combines two expressions, both of which must evaluate to
        `true`.
        -   **Syntax**: `<expr> and <expr>`
        -   **Example**: `func1(a) and func2(b)`
    -   **OR**: Combines two expressions, at least one of which must evaluate
        to `true`.
        -   **Syntax**: `<expr> or <expr>`
        -   **Example**: `rule1 or func1(a)`
    -   **NOT**: Negates an expression, returning `true` if the expression is
        `false`.
        -   **Syntax**: `not <expr>`
        -   **Example**: `not func1(a)`

3.  **Parentheses**:

    -   Used to group expressions and control evaluation precedence.
        -   **Syntax**: `(<expr>)`
        -   **Example**: `(func1(a) or func2(b)) and rule42`

4.  **Rule Expression**:
    -   Combines function calls and rule references into a logical expression.
        -   **Syntax**:
            ```
            <rule> ::= <expr>
            <expr> ::= <term> | <term> and <expr> | <term> or <expr>
            <term> ::= not <term> | (<expr>) | <functionCall> | <ruleRef>
            <functionCall> ::= <functionName>(<varList>)
            <ruleRef> ::= <ruleName>
            <varList> ::= <var> | <var>, <varList>
            <var> ::= <identifier>
            ```
        -   **Example**: `(func1(a) or func2(b)) and not rule42`

***

### Evaluation Rules:

1.  **Operator Precedence**:

    -   Highest: `not`
    -   Medium: `and`
    -   Lowest: `or`
    -   Parentheses override precedence.

2.  **Short-Circuit Evaluation**:

    -   **AND**: Stops evaluation if the first operand is `false`.
    -   **OR**: Stops evaluation if the first operand is `true`.

3.  **Validation**:
    -   All function names and rule references must be valid and previously
        defined.
    -   Variables in function calls must exist in the provided context.

***

### Examples of Rule Expressions:

1.  `rule1 = func1(a)`

    -   A simple rule that directly evaluates a function.

2.  `rule2 = func1(a) or func2(b)`

    -   Combines two functions using OR.

3.  `rule3 = not func1(a)`

    -   Negates the result of a function.

4.  `rule4 = (func1(a) or func2(b)) and rule2`

    -   Combines functions and previously defined rules with precedence.

5.  `rule5 = func3(c, d) and (not rule1 or func4(e))`
    -   A complex expression with multiple operators and grouping.
