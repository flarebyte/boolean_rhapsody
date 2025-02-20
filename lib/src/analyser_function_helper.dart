import 'expression_analyzer_result.dart';
import 'function_factory.dart';
import 'parser_options.dart';
import 'rule_expession.dart';
import 'token_stream.dart';

class RhapsodyAnalyserFunctionHelper {
  final RhapsodyAnalyserOptions options;

  RhapsodyAnalyserFunctionHelper({required this.options});

  RhapsodyExpressionAnalyserResult parseFunctionCall(
      RhapsodyTokenStream tokens) {
    final nameEnd = functionToken.indexOf('(');
    final functionName = functionToken.substring(0, nameEnd);
    final params = <String>[];

    var token = functionToken.substring(nameEnd + 1);
    while (!token.endsWith(')')) {
      params.add(token);
      token = tokens.consume().text;
    }
    params.add(token.substring(0, token.length - 1));

    final fn = BooleanRhapsodyFunctionFactory.create(functionName, params);
    final fnExpression = RhapsodyFunctionExpression(fn);
    return RhapsodyExpressionAnalyserResult(
        expression: fnExpression, requiredRules: []);
  }
}
