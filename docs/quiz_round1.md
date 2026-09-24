# TraeCode Quiz Round 1 — 预测输出

知识点范围：空安全、命名参数、整除

答题方式：先手写每道题的输出，再对照下方参考答案与讲解，把分歧记入末尾的进度报告。

---

## Q1 空安全 · `?` 可空类型与 `?.` 安全调用

```dart
String? name;
print(name?.length);
name = 'Dart';
print(name?.length);
```

### 参考输出

```
null
4
```

### 讲解

- `String?` 表示变量可以为 `null`。第一次 `print` 时 `name` 未赋值，默认为 `null`。
- `?.` 是安全调用：若接收者为 `null`，整个表达式直接返回 `null`，不抛异常。所以第一行输出 `null`。
- 第二次 `name = 'Dart'` 后，`?.length` 正常取长度，输出 `4`。

---

## Q2 空安全 · `??` 默认值

```dart
int? score;
final display = score ?? 0;
print(display);
score = 95;
print(score ?? 0);
```

### 参考输出

```
0
95
```

### 讲解

- `??` 是空合并运算符：左侧为 `null` 时取右侧值，否则取左侧值。
- 第一段 `score` 为 `null`，所以 `display = 0`。
- 第二段 `score = 95` 不为 `null`，直接取 `95`。
- 与 `?.` 的区别：`?.` 用于「安全访问成员」，结果是 `null` 或具体值；`??` 用于「给默认值」，结果一定非空。

---

## Q3 空安全 · `!` 非空断言

```dart
String? _f(bool f) => f ? 'X' : null;

void main() {
  final s = _f(true);
  print(s!.length);
}
```

### 参考输出

```
1
```

### 讲解

- `!` 是非空断言：把 `T?` 强制当作 `T` 使用。若运行时实际为 `null`，会抛 `Null check operator used on a null value`。
- 本题 `_f(true)` 返回 `'X'`，所以 `s!.length` 安全，输出 `1`。
- `??` 与 `!` 的核心区别：
  - `??` 是「兜底」：为空时走默认值，永远不会抛异常。
  - `!` 是「承诺」：你向编译器保证它非空，错了就崩。

---

## Q4 命名参数 · `required` 与默认值

```dart
String greet({required String name, String prefix = 'Hello'}) =>
    '$prefix, $name!';

void main() {
  print(greet(name: 'Dart'));
  print(greet(name: 'Dart', prefix: 'Hi'));
}
```

### 参考输出

```
Hello, Dart!
Hi, Dart!
```

### 讲解

- 花括号 `{}` 声明的是命名参数，调用时必须写参数名：`name: 'Dart'`。
- `required` 表示该参数必填，不能省略；省略 `name:` 会编译报错。
- `prefix = 'Hello'` 是默认值，调用时不传就取默认值，传了就覆盖。
- 第一行未传 `prefix`，输出 `Hello, Dart!`；第二行传 `prefix: 'Hi'`，输出 `Hi, Dart!`。

---

## Q5 整除 · `~/`、`/` 与 `%`

```dart
print(7 / 2);
print(7 ~/ 2);
print(7 % 2);
```

### 参考输出

```
3.5
3
1
```

### 讲解

- `/` 是浮点除法，结果一定是 `double`：`7 / 2 = 3.5`。
- `~/` 是整除，结果一定是 `int`，向下取整：`7 ~/ 2 = 3`。
- `%` 是取余：`7 % 2 = 1`。
- 易错点：把 `~/` 写成 `/` 会得到 `double`，传给 `int` 形参时会编译报错。

---

## 进度报告 · 分歧记录

| 题号 | 用户手写答案 | 参考答案 | 是否一致 | 分歧说明 |
| ---- | ------------ | -------- | -------- | -------- |
| Q1   | （待填）     | null / 4 | 待复核   |          |
| Q2   | （待填）     | 0 / 95   | 待复核   |          |
| Q3   | （待填）     | 1        | 待复核   |          |
| Q4   | （待填）     | Hello, Dart! / Hi, Dart! | 待复核 |  |
| Q5   | （待填）     | 3.5 / 3 / 1 | 待复核 |          |

### 关键概念小结

- `??` 与 `!` 的区别：`??` 是兜底防 `null`，永远安全；`!` 是承诺非空，错了就崩。
- 命名参数 `required` 不可省，默认值可省。
- 整数运算优先用 `~/`，避免 `double` 渗入 `int` 上下文。
