import 'package:code_builder/code_builder.dart';

String write(Iterable<Spec> specs) {
  final emitter = DartEmitter();
  if (specs.isEmpty) return '';
  return specs.map((spec) => spec.accept(emitter).toString()).join('\n\n');
}
