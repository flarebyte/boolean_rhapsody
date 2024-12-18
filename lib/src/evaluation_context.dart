class RhapsodyEvaluationContext {
  Map<String, String> variables;
  Map<String, String> constants;
  Map<String, String> parameters;
  Map<String, String> device;
  RhapsodyEvaluationContext(
      {required this.variables,
      required this.constants,
      required this.parameters,
      required this.device});

  String? getRefValue(String ref) {
    if (ref.startsWith('v:')) {
      return variables[ref];
    }
    if (ref.startsWith('c:')) {
      return constants[ref];
    }
    if (ref.startsWith('p:')) {
      return parameters[ref];
    }
    if (ref.startsWith('d:')) {
      return device[ref];
    }
    throw Exception("The ref $ref should starts with v: c: p: or d:");
  }
}
