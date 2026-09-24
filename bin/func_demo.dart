String enroll({
  required String name,
  required int age,
  String course = 'Dart Basics',
  String? nickname,
}) {
  final who = nickname ?? name;
  return '$who (age=$age) 已选课：$course';
}

int square(int n) => n * n;

String greet(String name) => 'Hello, $name!';

void demoFunctions() {
  print('--- 函数：命名参数 & 箭头函数 ---');
  print(enroll(name: '小明', age: 18));
  print(enroll(name: '小红', age: 20, course: 'Flutter 进阶', nickname: 'Red'));
  print('square(5) = ${square(5)}');
  print(greet('Dart'));
}
