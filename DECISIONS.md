# Architecture decision records

An [architecture
decision](https://cloud.google.com/architecture/architecture-decision-records)
is a software design choice that evaluates:

- a functional requirement (features).
- a non-functional requirement (technologies, methodologies, libraries).

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

    - Input: Map with `{ "abc123": true }`
    - Rule: `[v:abc123]`
    - Output: `true`

2.  **Combining Rules**:

    - Input: Map with `{ "abc123": true, "hgty89": false }`
    - Rule: `[v:abc123, f:and, v:hgty89]`
    - Output: `false`

3.  **Nested Rules**:

    - Input: Map with `{ "abc123": true, "rule34": false }`
    - Rule: `[r:rule34, f:or, v:abc123]`
    - Output: `true`

4.  **Parentheses for Precedence**:

    - Input: Map with `{ "abc123": true, "hgty89": false, "rule34": true }`
    - Rule: `[r:rule34, f:and, (, v:hgty89, f:or, v:abc123, )]`
    - Output: `true`

5.  **Variable Comparisons**:

    - Input: Map with `{ "gdj78": 10, "hkahs78": 5 }`
    - Rule: `[f:greaterThan, v:gdj78, v:hkahs78]`
    - Output: `true`

6.  **String Comparisons**:

    - Input: Map with `{ "term": "hello", "text": "hello world" }`
    - Rule: `[f:contains, v:term, v:text]`
    - Output: `true`

7.  **Constants as Variables**:
    - Input: Map with `{ "threshold": 10 }`
    - Rule: `[f:greaterThan, v:threshold, v:5]`
    - Output: `true`

### Edge Cases:

1.  **Undefined Variables**:

    - Input: Map with `{ "abc123": true }`
    - Rule: `[v:undefinedVar]`
    - Expected Behavior: Validation error.

2.  **Unbalanced Parentheses**:

    - Rule: `[r:rule34, (, v:abc123, f:or, r:rule35]`
    - Expected Behavior: Validation error.

3.  **Invalid Tokens**:

    - Rule: `[x:invalidToken, v:abc123]`
    - Expected Behavior: Validation error.

4.  **Type Mismatches**:

    - Input: Map with `{ "abc123": 10 }`
    - Rule: `[f:contains, v:abc123, v:text]`
    - Expected Behavior: Validation error due to type incompatibility.

5.  **Empty Rules**:

    - Rule: `[]`
    - Expected Behavior: Validation error.

6.  **Recursive Rules**:
    - Rule: `[r:ruleA, r:ruleA]`
    - Expected Behavior: Validation error or loop prevention.

### DSL Specification:

1.  **Tokens**:

    - `v:`: Represents a variable. Must match a key in the input map.
    - `r:`: Represents a rule. Should reference another rule in the system.
    - `f:`: Represents a function. Includes logical operators (`and`, `or`,
      `not`), comparison functions (`greaterThan`, `contains`), and custom
      functions.

2.  **Operators**:

    - `f:and`, `f:or`, `f:not`: Logical operators.
    - `f:greaterThan`, `f:lessThan`, `f:equals`: Numeric comparisons.
    - `f:contains`: String containment check.

3.  **Parentheses**:

    - Used for grouping and precedence, represented as `(` and `)`.

4.  **Constants**:

    - Treated as variables, allowing consistent token validation.

5.  **Validation Rules**:
    - Tokens must adhere to one of the predefined prefixes (`v:`, `r:`,
      `f:`).
    - Parentheses must be balanced.
    - Variables and rules must be defined.
    - Type compatibility must be enforced during evaluation.

### Scope and Limitations:

1.  **Scope**:

    - Evaluate boolean rules with a mix of logical operators and custom
      functions.
    - Handle string and numeric comparisons.
    - Ensure clear precedence with parentheses.

2.  **Out of Scope**:

    - Free text evaluation outside the defined variable map.
    - Advanced data structures like arrays or objects.
    - Implicit type conversions (e.g., comparing strings to numbers).
    - Complex dependency graphs with cyclic references.

3.  **Examples of Out of Scope**:
    - Rule: `[v:abc123, f:contains, "freeText"]` → Invalid.
    - Rule: `[v:abc123, f:and, { complex: "data" }]` → Invalid.

## Specification Refinement

#### Function Names and Behaviors:

1.  **Undefined Variable Check**

    - **Name**: `isUndefined`
    - **Description**: Returns `true` if the variable is not defined in the
      input map.

2.  **Empty String Check**

    - **Name**: `isEmptyString`
    - **Description**: Returns `true` if the variable is an empty string
      (`""`).

3.  **Non-Whitespace String Check**

    - **Name**: `hasNonWhitespaceChar`
    - **Description**: Returns `true` if the variable is a string with at
      least one non-whitespace character.

4.  **Whitespace-Only String Check**

    - **Name**: `isWhitespace`
    - **Description**: Returns `true` if the variable is a string containing
      only whitespace characters.

5.  **Multiple Lines Check**

    - **Name**: `isMultiline`
    - **Description**: Returns `true` if the variable contains multiple lines
      (e.g., contains `\n`).

6.  **Single Line Check**

    - **Name**: `isSingleLine`
    - **Description**: Returns `true` if the variable contains only a single
      line.

7.  **Substring Containment Check**

    - **Name**: `containsTerm`
    - **Description**: Returns `true` if the term (variable) is contained in
      the text (variable).

8.  **Prefix Check**

    - **Name**: `startsWith`
    - **Description**: Returns `true` if the text (variable) starts with the
      prefix (variable).

9.  **Suffix Check**

    - **Name**: `endsWith`
    - **Description**: Returns `true` if the text (variable) ends with the
      suffix (variable).

10. **Equality Check**

    - **Name**: `equals`
    - **Description**: Returns `true` if the text (variable) equals the other
      text (variable).

11. **Keyword Containment Check**

    - **Name**: `containsAnyKeywords`
    - **Description**: Returns `true` if the text (variable) contains any
      keywords from the keyword list (variable). An optional separator
      (variable) determines keyword splitting; defaults to line breaks
      (`\n`).

12. **Numeric Comparisons**:

    - **Name**: `isNumberGreaterThan`
      - **Description**: Returns `true` if the numeric value of text (variable)
        is greater than the threshold (variable).
    - **Name**: `isNumberLessThan`
      - **Description**: Returns `true` if the numeric value of text (variable)
        is less than the threshold (variable).
    - **Name**: `isNumberEqualTo`
      - **Description**: Returns `true` if the numeric value of text (variable)
        equals the threshold (variable).

13. **Length Comparisons**:
    - **Name**: `isLengthEqualTo`
      - **Description**: Returns `true` if the length of the text (variable)
        equals the threshold (variable).
    - **Name**: `isLengthLessThan`
      - **Description**: Returns `true` if the length of the text (variable) is
        less than the threshold (variable).
    - **Name**: `isLengthGreaterThan`
      - **Description**: Returns `true` if the length of the text (variable) is
        greater than the threshold (variable).

## Specification: Grammar for Boolean Rule Expressions

### Grammar Components:

1.  Primitive Elements:

    - **Function Call**: A boolean function applied to a list of variables.
      - **Syntax**: `<functionName>(<var1>, <var2>, ...)`
      - **Example**: `func1(a)`, `func2(b, c)`
    - **Rule Reference**: A reference to a previously defined rule.
      - **Syntax**: `<ruleName>`
      - **Example**: `rule42`

2.  Logical Operators:

    - **AND**: Combines two expressions, both of which must evaluate to
      `true`.
      - **Syntax**: `<expr> and <expr>`
      - **Example**: `func1(a) and func2(b)`
    - **OR**: Combines two expressions, at least one of which must evaluate
      to `true`.
      - **Syntax**: `<expr> or <expr>`
      - **Example**: `rule1 or func1(a)`
    - **NOT**: Negates an expression, returning `true` if the expression is
      `false`.
      - **Syntax**: `not <expr>`
      - **Example**: `not func1(a)`

3.  Parentheses:

    - Used to group expressions and control evaluation precedence.
      - **Syntax**: `(<expr>)`
      - **Example**: `(func1(a) or func2(b)) and rule42`

4.  Rule Expression:

    - Combines function calls and rule references into a logical expression.
      - **Syntax**:
        ```bnf
        <rule> ::= <expr>
        <expr> ::= <term> | <term> and <expr> | <term> or <expr>
        <term> ::= not <term> | (<expr>) | <functionCall> | <ruleRef>
        <functionCall> ::= <functionName>(<varList>)
        <ruleRef> ::= <ruleName>
        <varList> ::= <var> | <var>, <varList>
        <var> ::= <identifier>
        ```
      - **Example**: `(func1(a) or func2(b)) and not rule42`

5.  Rule Expression compatible with Recursive descent and LL(1) parsers

```bnf
<rule> ::= <expr>
<expr> ::= <term> <expr_tail>
<expr_tail> ::= and <term> <expr_tail> | or <term> <expr_tail> | ε
<term> ::= not <term> | ( <expr> ) | <functionCall> | <ruleRef>
<functionCall> ::= <functionName> ( <varList> )
<ruleRef> ::= <ruleName>
<varList> ::= <var> <varList_tail> | ε
<varList_tail> ::= , <var> <varList_tail> | ε
<var> ::= <identifier>
<functionName> ::= <identifier>
<ruleName> ::= <identifier>
<identifier> ::= ... (Define the identifier syntax here)
```

Abstracting away the internal details of functionCall and treat it as a single, indivisible token from the parser's perspective:

```bnf
<rule> ::= <expr>  // Example: func1(a) and rule2

<expr> ::= <term> <expr_tail> // Example: func1(a) or rule2
<expr_tail> ::= and <term> <expr_tail> | or <term> <expr_tail> | ε // Example: and not rule3, or func2(b), or nothing (ε)

<term> ::= not <term> | ( <expr> ) | <functionCall> | <ruleRef> // Examples: not func1(a), (func1(a) or rule2), func1(a), rule2

<functionCall> ::= (Predefined function call token) // Example: func1(a, b) (Tokenized as a single unit by the lexer)

<ruleRef> ::= <ruleName> // Example: rule42

<ruleName> ::= <identifier> // Example: rule42

<identifier> ::= ... (Define the identifier syntax here) // Example: a, b, func1, rule42 (Depends on your specific identifier rules)
```

### Evaluation Rules:

1.  **Operator Precedence**:

    - Highest: `not`
    - Medium: `and`
    - Lowest: `or`
    - Parentheses override precedence.

2.  **Short-Circuit Evaluation**:

    - **AND**: Stops evaluation if the first operand is `false`.
    - **OR**: Stops evaluation if the first operand is `true`.

3.  **Validation**:
    - All function names and rule references must be valid and previously
      defined.
    - Variables in function calls must exist in the provided context.

---

### Examples of Rule Expressions:

1.  `rule1 = func1(a)`

    - A simple rule that directly evaluates a function.

2.  `rule2 = func1(a) or func2(b)`

    - Combines two functions using OR.

3.  `rule3 = not func1(a)`

    - Negates the result of a function.

4.  `rule4 = (func1(a) or func2(b)) and rule2`

    - Combines functions and previously defined rules with precedence.

5.  `rule5 = func3(c, d) and (not rule1 or func4(e))`
    - A complex expression with multiple operators and grouping.

## Specification: Rule Evaluation Order and Validation

### Rule Resolution Order:

1.  **Independent Rules (No Dependencies)**:

    - Rules that do not reference any other rules are evaluated first.
    - These evaluations can be performed in parallel for efficiency.

2.  **Dependent Rules (Sequential Evaluation)**:
    - Rules that reference other rules are evaluated in a sequence, ensuring
      a rule is only evaluated after all rules it depends on are resolved.
    - Dependency chains are followed in the correct order.

---

### Validation Requirements:

1.  **Circular Dependency Detection**:

    - Any circular dependency among rules (e.g., `rule1 -> rule2 -> rule1`)
      should trigger an error.
    - The system must validate the dependency graph before evaluation and
      provide a clear error message indicating the problematic cycle.

2.  **Syntax Validation**:

    - Parentheses in the rule expressions must be balanced.
    - Each token in the rule expression must be valid:
      - Functions must exist and accept the correct number of variables.
      - Rule references must point to defined rules.
      - Variables must exist in the evaluation context.

3.  **Dependency Consistency**:

    - Rules must reference only rules that are valid and properly defined.
    - A rule cannot reference itself directly (e.g., `rule1 = rule1`) or
      indirectly (e.g., `rule1 = rule2 and rule2 = rule1`).

4.  **Error Handling**:
    - Circular dependencies, syntax errors, or undefined references must halt
      the evaluation with detailed error messages indicating the cause and
      location of the issue.

---

### Execution Algorithm:

1.  **Parse and Validate**:

    - Parse all rules into an internal representation (e.g., an abstract
      syntax tree or dependency graph).
    - Validate syntax, rule references, and detect circular dependencies.

2.  **Dependency Analysis**:

    - Build a dependency graph where each rule is a node, and dependencies
      are directed edges.
    - Identify independent rules (nodes with no incoming edges) for parallel
      evaluation.
    - Topologically sort dependent rules to determine evaluation order.

3.  **Evaluate Rules**:
    - Evaluate independent rules first (in parallel if supported).
    - Sequentially evaluate dependent rules following the topological order
      of the dependency graph.

---

### Constraints and Examples:

#### Example 1: Valid Rule Set

- `rule1 = func1(a)`
- `rule2 = func2(b)`
- `rule3 = rule1 and rule2`
- Resolution Order:
  1.  `rule1`, `rule2` (parallel)
  2.  `rule3`

#### Example 2: Circular Dependency

- `rule1 = rule2 and func1(a)`
- `rule2 = rule1 or func2(b)`
- Result: Circular dependency error.

#### Example 3: Syntax Error

- `rule1 = func1(a`
- Result: Syntax error due to unbalanced parentheses.

#### Example 4: Undefined Reference

- `rule1 = rule2 and func1(a)`
- Result: Error due to undefined rule `rule2`.

---

### Notes:

- The system should prioritize early detection of errors (syntax,
  circular dependencies) before attempting evaluation.
- For scalability, dependency analysis and parallel evaluation should be
  optimized for large rule sets.

## Algorithms for Ordering Rules Based on Dependencies

The problem of ordering rules for evaluation can be mapped to **topological
sorting** of a **directed acyclic graph (DAG)**, where:

- **Nodes** represent rules.
- **Edges** represent dependencies between rules (e.g., `rule1 -> rule23`
  means `rule1` depends on `rule23`).

Below are a few algorithms to handle this problem, followed by a discussion
on using sets to represent dependencies.

---

### 1. **Kahn’s Algorithm**

- **Description**:

  - Kahn's algorithm is an iterative approach to perform topological
    sorting of a DAG.
  - It works by identifying nodes with no incoming edges (independent
    rules) and removing them from the graph while recording their order.

- **Steps**:

  1.  Calculate the in-degree (number of incoming edges) for each rule.
  2.  Add all rules with in-degree `0` to a queue (independent rules).
  3.  While the queue is not empty:
      - Remove a rule from the queue and add it to the sorted order.
      - For each dependent rule, reduce its in-degree by `1`.
      - If a rule’s in-degree becomes `0`, add it to the queue.
  4.  If all rules are processed, return the sorted order. If not, a cycle exists.

- **Complexity**:

  - Time: (O(V + E)), where (V) is the number of rules and (E) is the
    number of dependencies.
  - Space: (O(V + E)) for storing the graph and in-degrees.

- **Advantages**:
  - Simple to implement and efficient for DAGs.

---

### 2. **Depth-First Search (DFS) with Post-Order Traversal**

- **Description**:

  - DFS can also be used for topological sorting by recording the
    post-order traversal of the graph.
  - Nodes are added to the sorted order in reverse post-order (process
    after visiting all children).

- **Steps**:

  1.  Create a visited set to track processed nodes.
  2.  Perform a DFS starting from each unvisited rule:
      - Mark the current rule as visited.
      - Recursively visit all dependent rules.
      - Add the current rule to a stack when all its dependencies are
        processed.
  3.  Reverse the stack to get the sorted order.
  4.  Detect cycles by tracking nodes in the current path (using a separate "currently visiting" set).

- **Complexity**:

  - Time: (O(V + E)), where (V) is the number of rules and (E) is the
    number of dependencies.
  - Space: (O(V + E)) for storing the graph and recursion stack.

- **Advantages**:
  - Intuitive and well-suited for recursive implementations.

---

### 3. **Using Sets to Represent Dependencies**

- **Description**:

  - Represent each rule’s dependencies as a set (e.g., `rule1 = Set(rule23,
var12, var23)`).
  - Process rules iteratively by removing those with no dependencies and
    resolving their impact on other rules.

- **Steps**:

  1.  Create a mapping of each rule to its dependency set.
  2.  Identify all rules with an empty dependency set (independent rules).
  3.  Add independent rules to the sorted order and remove them from all dependency sets.
  4.  Repeat until no rules remain in the mapping.
  5.  If any rules remain with unresolved dependencies, a cycle exists.

- **Complexity**:

  - Time: (O(V^2)) in the worst case (iteratively checking and modifying
    sets).
  - Space: (O(V^2)) for storing dependency sets.

- **Advantages**:
  - Conceptually simple and avoids explicit edge-based graph
    representation.
  - Dependencies are directly tied to the rule definitions.

---

### Choosing an Algorithm

- **Kahn’s Algorithm**: Best for performance and straightforward
  implementation in DAGs.
- **DFS**: Ideal for recursion-based solutions and cycle detection.
- **Set Representation**: Useful for small-scale problems or when
  dependencies are naturally represented as sets in the input.

---

### Example with Set Representation

#### Input:

```
rule1 = Set(rule2, var1)
rule2 = Set(var3)
rule3 = Set(rule1, var2)
```

#### Steps:

1.  Start with rules that have no dependencies on other rules:
    - `rule2` depends only on `var3` (resolved via context).
2.  Remove `rule2` and resolve its impact:
    - Remove `rule2` from `rule1`’s dependency set.
3.  Proceed to `rule1`, then `rule3`.
4.  If any rule still has dependencies, report a cycle.

#### Result:

- Sorted order: `[rule2, rule1, rule3]`
- Cycle detection: If a rule still has dependencies after all iterations.

---

### Conclusion

- Using sets to represent dependencies provides a direct and readable way
  to manage rule relationships.
- For larger or more complex graphs, algorithms like Kahn’s or DFS are
  more efficient and scalable.
