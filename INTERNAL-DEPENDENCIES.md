# Internal dependencies

## Simplified

```mermaid
  graph TD
  EntryPoint --> EvaluationEngine
  EntryPoint --> Parser
  EntryPoint --> SyntaxAnalysis
  EntryPoint --> SemanticAnalysis
  EntryPoint --> FunctionLibrary
  EntryPoint --> DomainModel

  Parser --> DomainModel

  SyntaxAnalysis --> Parser
  SyntaxAnalysis --> DomainModel
  SyntaxAnalysis --> AST_Expressions

  SemanticAnalysis --> SyntaxAnalysis
  SemanticAnalysis --> Parser
  SemanticAnalysis --> AST_Expressions
```

## Detailed

![internal depencies diagram](doc/internal_dependencies.png)
