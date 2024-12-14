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

abstract class BooleanRhapsodyFunction {
  bool isTrue(RhapsodyEvaluationContext context);
  basicValidateParams(
      {required List<String> refs,
      required int minSize,
      required int maxSize,
      required String name}) {
    final size = refs.length;
    if (size < minSize) {
      throw Exception(
          "The number of parameters for the function $name was $size but was expecting a minimum of $minSize for $refs");
    }
    if (size > maxSize) {
      throw Exception(
          "The number of parameters for the function $name was $size but was expecting a maximum of $maxSize for $refs");
    }
    final hasUnsupportedPrefix = refs
        .where((param) => !(param.startsWith('v:') || (param.startsWith('c:'))))
        .isNotEmpty;
    if (hasUnsupportedPrefix) {
      throw Exception(
          "The references for the function $name should all starts with v: or c: for $refs");
    }
  }
}

class IsAbsentRhapsodyFunction extends BooleanRhapsodyFunction {
  final List<String> refs;
  IsAbsentRhapsodyFunction({required this.refs}) {
    basicValidateParams(refs: refs, minSize: 1, maxSize: 1, name: 'isAbsent');
  }

  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return value == null;
  }
}

class BooleanRhapsodyFunctionFactory {
  static BooleanRhapsodyFunction create(String name, List<String> params) {
    switch (name) {
      case 'isAbsent':
        return IsAbsentRhapsodyFunction(refs: params);
      default:
        throw Exception("The boolean function $name is unknown");
    }
  }
}
