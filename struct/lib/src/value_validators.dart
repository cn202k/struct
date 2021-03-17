abstract class ValueValidator<T> {
  String? test(T value);
}

class length implements ValueValidator<String?> {
  final int? min;
  final int? max;

  const length({this.min, this.max});

  @override
  String? test(String? value) {
    if (value == null) return null;
    final min = this.min ?? 0;
    final max = this.max ?? value.length;
    final len = value.length;
    if (min <= len && len <= max) return null;
    return "The string has invalid length";
  }
}

class NotEmpty implements ValueValidator<String?> {
  const NotEmpty();

  @override
  String? test(String? value) {
    if (value == null) return null;
    if (value.isNotEmpty) return null;
    return 'The string should not be empty';
  }
}

const notEmpty = NotEmpty();
