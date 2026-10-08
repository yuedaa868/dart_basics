// 自主实践任务1：空安全改写
// 把"滥用 ! 的定时炸弹"改为"不会抛异常的安全版本"，并对比三种写法的取舍。

String? _fetchUser(bool ok) => ok ? 'TraeCode' : null;

// 1) 危险版：! 强制解包，_fetchUser(false) 会抛 'Null check operator used on a null value'
String dangerousName(bool ok) => _fetchUser(ok)!;

// 2) 安全版 A：?? 兜底，结果一定非空，永不崩溃
String safeWithDefault(bool ok) => _fetchUser(ok) ?? '游客';

// 3) 安全版 B：?. + null 检查走分支，null 与非 null 走不同逻辑
String safeWithBranch(bool ok) {
  final raw = _fetchUser(ok);
  if (raw != null) {
    return 'Welcome, $raw';
  }
  return 'Welcome, 游客';
}

void demoNullSafetyRewrite() {
  print('--- 自主实践 · 空安全改写 ---');
  print('dangerousName(true)  = ${dangerousName(true)}');
  // 不调用 dangerousName(false)，否则会抛异常导致后续代码不执行

  print('safeWithDefault(false) = ${safeWithDefault(false)}');
  print('safeWithDefault(true)  = ${safeWithDefault(true)}');

  print('safeWithBranch(false)  = ${safeWithBranch(false)}');
  print('safeWithBranch(true)   = ${safeWithBranch(true)}');

  print('\n[结论]');
  print('- ! 是"承诺非空"，错了就崩 → 仅在 100% 确定非空时用');
  print('- ?? 是"兜底"，永远安全 → 需要给默认值时首选');
  print('- ?. + null 检查 → 需要在 null 与非 null 走不同逻辑时用');
}
