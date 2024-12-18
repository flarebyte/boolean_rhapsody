class RhapsodyEvaluationContext {
  Map<String, String> variables;
  Map<String, String> constants;
  RhapsodyEvaluationContext({required this.variables, required this.constants});

  String? getRefValue(String ref) {
    if (ref.startsWith('v:')) {
      return variables[ref];
    }
    if (ref.startsWith('c:')) {
      return constants[ref];
    }
    throw Exception("The ref $ref should starts with v: or c:");
  }
}
