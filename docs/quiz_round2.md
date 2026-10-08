# TraeCode Quiz Round 2 — 实操改写

知识点范围：空安全改写、命名参数设计、控制流小程序

答题方式：先在「用户作答区」手写代码，再对照下方参考答案与讲解，把分歧记入末尾的进度报告。

> 本轮与 Round 1 的区别：Round 1 是「预测输出」，本轮是「写代码」——改写、设计、实现。

---

## Q1 空安全改写 · 把滥用的 `!` 改成不会崩的版本

### 题目

下面这段代码在 `_fetchUser(false)` 返回 `null` 时会崩溃。请改写为「不会抛异常」的安全版本，并说明你用了哪些空安全机制（`?` / `?.` / `??` / `!`）以及为什么不再用 `!`。

```dart
String? _fetchUser(bool ok) => ok ? 'TraeCode' : null;

void main() {
  String name = _fetchUser(false)!;
  print('Welcome, $name');
}
```

### 用户作答区

```dart
String? _fetchUser(bool ok) => ok ? 'TraeCode' : null;

void main() {
  final name = _fetchUser(false) ?? '游客';
  print('Welcome, $name');
}
```

**我的解释**：

```
用了 ?? 兜底：左侧 _fetchUser(false) 返回 null 时，?? 取右侧 '游客'，
整个表达式一定非空，name 被推断为 String，永不崩溃。
不再用 ! 是因为 ! 是"承诺非空"，运行时若为 null 会直接抛
'Null check operator used on a null value'，是定时炸弹。
Round 1 学到的口诀：?? 是兜底（永远安全），! 是承诺（错了就崩）。
```

### 参考答案

```dart
String? _fetchUser(bool ok) => ok ? 'TraeCode' : null;

void main() {
  final name = _fetchUser(false) ?? '游客';
  print('Welcome, $name');
}
```

### 讲解

- 原代码 `String name = _fetchUser(false)!` 把可空值强制解包，运行时若为 `null` 会抛 `Null check operator used on a null value`，是「定时炸弹」。
- 改用 `??` 兜底：左侧为 `null` 时取右侧默认值 `'游客'`，整个表达式一定非空，`name` 可推断为 `String`，永不崩溃。
- 也可以用「`?.` + null 检查」走分支逻辑：

  ```dart
  final raw = _fetchUser(false);
  if (raw != null) {
    print('Welcome, $raw');
  } else {
    print('Welcome, 游客');
  }
  ```

- 三种方式取舍：
  - `!`：只在 100% 确定非空时用，否则是炸弹。
  - `??`：需要给默认值时首选，结果一定非空。
  - `?.` + null 检查：需要在 null 与非 null 走不同逻辑时用。
- 本题需求是「给个兜底名字」，所以 `??` 最贴切。

---

## Q2 命名参数设计 · 为「注册课程」设计合理签名

### 题目

设计一个 `enrollCourse` 函数，要求：

- 学员姓名：必填
- 年龄：必填
- 课程名：可选，默认 `'Dart Basics'`
- 优惠码：可选，可能没有（可空，无默认值）
- 是否开发票：可选，默认 `false`

函数返回一段描述字符串，例如：

```
小明 (age=18) 已选课：Dart Basics
小红 (age=20) 已选课：Flutter (优惠码: NEW100) [已开票]
```

请写出函数签名和函数体，再写两行调用示例。

### 用户作答区

```dart
String enrollCourse({
  required String name,
  required int age,
  String course = 'Dart Basics',
  String? coupon,
}) {
  return '$name (age=$age) 已选课：$course (优惠码: $coupon)';
}

void main() {
  print(enrollCourse(name: '小明', age: 18));
  print(enrollCourse(name: '小红', age: 20, course: 'Flutter', coupon: 'NEW100'));
}
```

### 参考答案

```dart
String enrollCourse({
  required String name,
  required int age,
  String course = 'Dart Basics',
  String? coupon,
  bool invoice = false,
}) {
  final tag = coupon == null ? '' : ' (优惠码: $coupon)';
  final bill = invoice ? ' [已开票]' : '';
  return '$name (age=$age) 已选课：$course$tag$bill';
}

void main() {
  print(enrollCourse(name: '小明', age: 18));
  print(enrollCourse(
    name: '小红',
    age: 20,
    course: 'Flutter',
    coupon: 'NEW100',
    invoice: true,
  ));
}
```

### 讲解

- 姓名和年龄是必填信息 → 用 `required` 修饰，调用时漏传会**编译报错**，比运行时报错安全。
- 课程名有合理默认值 → `String course = 'Dart Basics'`，调用方不传就走默认。
- 优惠码可能没有 → `String? coupon`，可空、无默认值，不传时为 `null`。
- 开发票是布尔开关 → `bool invoice = false`，默认不开。
- 设计原则：
  - 必填 → `required`，让编译器帮你查漏。
  - 有合理默认值 → 直接给默认值，减少调用方负担。
  - 可选且无默认值 → 可空类型 `T?`。
  - 布尔开关默认值 → 选「更安全/更常见」的那个（这里默认不开票）。
- 函数体内用 `coupon == null ? '' : '...'` 处理可空参数，避免在字符串里出现 `null` 字样。

---

## Q3 控制流小程序 · 成绩分级器

### 题目

写一个 `gradeOf(int score)` 函数，分级规则：

- `90–100` → `A`
- `80–89` → `B`
- `70–79` → `C`
- `60–69` → `D`
- `0–59` → `F`
- 其他（`<0` 或 `>100`）→ `X`（无效）

再用 `for-in` 遍历 `[95, 82, 73, 64, 55, 101, -5]`，对每个分数打印 `分数 X -> 等级 Y`。

### 用户作答区

```dart
String gradeOf(int score) {
  if (score >= 90) {
    return 'A';
  } else if (score >= 80) {
    return 'B';
  } else if (score >= 70) {
    return 'C';
  } else if (score >= 60) {
    return 'D';
  } else {
    return 'F';
  }
}

void main() {
  for (final s in [95, 82, 73, 64, 55, 101, -5]) {
    print('分数 $s -> 等级 ${gradeOf(s)}');
  }
}
```

### 参考答案

```dart
String gradeOf(int score) {
  if (score < 0 || score > 100) {
    return 'X';
  } else if (score >= 90) {
    return 'A';
  } else if (score >= 80) {
    return 'B';
  } else if (score >= 70) {
    return 'C';
  } else if (score >= 60) {
    return 'D';
  } else {
    return 'F';
  }
}

void main() {
  for (final s in [95, 82, 73, 64, 55, 101, -5]) {
    print('分数 $s -> 等级 ${gradeOf(s)}');
  }
}
```

### 参考输出

```
分数 95 -> 等级 A
分数 82 -> 等级 B
分数 73 -> 等级 C
分数 64 -> 等级 D
分数 55 -> 等级 F
分数 101 -> 等级 X
分数 -5 -> 等级 X
```

### 讲解

- **边界判断顺序很关键**：先排除「越界」（`<0 || >100`），再做分段。如果先写 `score >= 90` 再写越界检查，`101` 会错误命中 `A`。
- `if - else if` 链从上往下匹配，命中一个就跳出，所以把「最特殊/最严格」的条件放前面（越界检查最特殊，放第一）。
- `for-in` 遍历 `List<int>` 字面量 `[...]`，每个元素取出后调用 `gradeOf`，再用字符串插值 `${gradeOf(s)}` 拼进输出。
- 易错点：把 `>= 90` 写成 `> 90`，会把 `90` 漏到下一档；边界值要用 `>=` 含等号。

---

## 进度报告 · 分歧记录

| 题号 | 主题 | 用户作答摘要 | 参考答案要点 | 是否一致 | 分歧说明 |
| ---- | ---- | ------------ | ------------ | -------- | -------- |
| Q1   | 空安全改写 | `?? '游客'` 兜底，name 推断为 String | `??` 兜底，结果非空 | 一致 | 思路与参考答案完全一致：Round 1 刚学过 `??` 是兜底、`!` 是承诺，本题需求是"给个兜底名字"，`??` 最贴切。无分歧。 |
| Q2   | 命名参数设计 | 漏掉 `bool invoice` 参数；函数体直接 `'$coupon'` 插值 | `required` 必填 + 默认值 + `T?` 可选 + `bool invoice=false`；用 null 检查处理可空参数 | 不一致 | 两处分歧：(1) 审题漏看"是否开发票"需求，少一个 `bool invoice = false` 参数——审题不细是硬伤；(2) 函数体直接 `'$coupon'` 插值，当 coupon 为 null 时会输出"优惠码: null"字样，应改为 `coupon == null ? '' : ' (优惠码: $coupon)'` 处理可空参数。修正后与参考答案一致。 |
| Q3   | 控制流小程序 | 漏掉越界检查，直接 `>= 90` 起步分段 | 先越界检查（`<0 \|\| >100`）再分段，`for-in` 遍历 | 不一致 | 分歧：我的版本 101 错误命中 A、-5 错误命中 F，而参考答案返回 X。根因是没先排除越界就直接分段。修正：在 if-else if 链最前面加 `if (score < 0 \|\| score > 100) return 'X';`。教训：边界判断顺序很关键，特殊条件（越界）先行，否则越界值会"穿透"到正常分段。 |

### 关键概念小结

- `!` 是承诺非空，错了就崩；`??` 是兜底，永远安全。生产代码优先 `??`。
- 命名参数设计三件套：`required`（必填）+ `= 默认值`（有默认）+ `T?`（可空可选）。
- `if-else if` 链：特殊条件（越界）先行，边界值用 `>=` 含等号，避免漏档。
