# Internal dependencies

## Simplified

```mermaid
  graph TD
  DSL_API --> Evaluation
  DSL_API --> Tokenization
  DSL_API --> Parsing
  DSL_API --> Semantic_Analysis
  DSL_API --> Functions
  DSL_API --> Comparators
  DSL_API --> Expression_Model
  DSL_API --> Execution
  
  Parsing --> Tokenization
  Parsing --> Expression_Model

  Semantic_Analysis --> Parsing
  Semantic_Analysis --> Expression_Model
  Semantic_Analysis --> Execution

  Functions --> Evaluation
  Functions --> Comparators

  Expression_Model --> Evaluation
  Expression_Model --> Functions

  Execution --> Evaluation

  Comparators

```

## Detailed

![internal depencies diagram](doc/internal_dependencies.png)
