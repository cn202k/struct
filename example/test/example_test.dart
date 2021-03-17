void main() {
  final s = ' {int<int?, String>? [ac]d*} ';
  final reg = RegExp(r'\*|\[|\]|\{|\}');
  print(s.replaceAll(reg, '#'));
}
