void main() {
  // final s = '@anno(const [1, 2]) Map< List<String>, int>';
  // final reg = RegExp(r'\w+(<(\w|,|<|>|\w)+>)?$');
  // print(s.replaceAll(reg, '#'));

  final s =
      ' @abd(const [1, 2]) Function < List <Stri0_ng ? >, bool Function(int), f(int) > ?';
  // final generics = RegExp(r'\w+\s+<(\w|\?|,|<|>|\(|\)|\s)+>\s*\??$');
  final generics = r'<(\w|\?|,|<|>|\(|\)|\s)+>';
  final identifier = r'\w+';
  final nullSuffix = r'\?';
  final type = [identifier, '($generics)?', '$nullSuffix?'].join(r'\s*');
  final regex = '$type\$';
  print(regex);
  final m = RegExp(regex).firstMatch(s);
  print(m != null ? m.group(0) : 'not found');
}
