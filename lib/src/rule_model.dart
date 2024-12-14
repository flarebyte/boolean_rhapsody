class RhapsodyEvaluationContext { 
  Map<String, String> variables;
  Map<String, String> constants;
  RhapsodyEvaluationContext({required this.variables, required this.constants});

  String? getRefValue(String ref){
    if (ref.startsWith('v:')){
      return variables[ref];
    }
    if (ref.startsWith('c:')){
      return constants[ref];
    }
    throw Exception("The ref $ref should starts with v: or c:");
  }

}

abstract class BooleanRhapsodyFunction {
  bool isTrue(RhapsodyEvaluationContext context);
  basicValidateParams(List<String> refs, int minSize, int maxSize){
    final size = refs.length;
    if (size<minSize){
      throw Exception("Size was $size but was expecting a minimum of $minSize for $refs");
    }
    if (size>maxSize){
      throw Exception("Size was $size but was expecting a maximum of $maxSize for $refs");
    }
    final hasUnsupportedPrefix = refs.where((param) => !(param.startsWith('v:')||(param.startsWith('c:')))).isNotEmpty;
    if (hasUnsupportedPrefix){
      throw Exception("The references should all starts with v: or c: for $refs");
    }
  }
}



class isUndefinedRhapsodyFunction extends BooleanRhapsodyFunction{
  List<String> refs;
  isUndefinedRhapsodyFunction({required this.refs}){
    basicValidateParams(refs, 1, 1);
  }

  @override
  bool isTrue(RhapsodyEvaluationContext context) {
    final value = context.getRefValue(refs[0]);
    return value == null;
  }

}

class BooleanRhapsodyFunctionFactory {
  
  static BooleanRhapsodyFunction create(String name){

  }

}
