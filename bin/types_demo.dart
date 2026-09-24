String? _lookupName(bool found) => found ? 'TraeCode' : null;

void demoVariables() {
  print('--- 变量声明 ---');
  var name = 'Dart';
  final year = 2024;
  const pi = 3.14159;
  int score = 95;
  print('name=$name (runtime ${name.runtimeType}), year=$year, pi=$pi, score=$score');
}

void demoInterpolation() {
  print('--- 字符串插值 ---');
  final lang = 'Dart';
  final version = 3.13;
  print('语言：$lang，版本：$version');
  print('大写语言名：${lang.toUpperCase()}');
  print('计算：1 + 2 * 3 = ${1 + 2 * 3}');
}

void demoNullSafety() {
  print('--- 空安全四件套 ---');
  String? maybeName = _lookupName(false);
  print('1) ? 可空类型: maybeName = $maybeName');

  print('2) ?. 安全调用: maybeName?.length = ${maybeName?.length}');

  final display = maybeName ?? '匿名';
  print('3) ?? 默认值: display = $display');

  maybeName = _lookupName(true);
  final forced = maybeName!.length;
  print('4) ! 非空断言: maybeName!.length = $forced');
}
