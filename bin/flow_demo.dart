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

void demoForIn() {
  print('--- for-in 循环 ---');
  const scores = [95, 82, 73, 64, 55];
  for (final s in scores) {
    print('分数 $s -> 等级 ${gradeOf(s)}');
  }

  final names = {'Alice', 'Bob', 'Cara'};
  for (final n in names) {
    print('学员：$n');
  }
}
