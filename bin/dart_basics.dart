import 'types_demo.dart';
import 'func_demo.dart';
import 'flow_demo.dart';
import 'nullable_rewrite.dart';

void main(List<String> arguments) {
  print('=== Dart 基础语法合集 ===\n');

  demoVariables();
  print('');
  demoInterpolation();
  print('');
  demoNullSafety();
  print('');

  demoFunctions();
  print('');

  demoForIn();
  print('');

  demoNullSafetyRewrite();

  print('\n=== 全部演示结束 ===');
}
