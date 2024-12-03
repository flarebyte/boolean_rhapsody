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

