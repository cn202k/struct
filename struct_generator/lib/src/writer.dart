import 'package:code_builder/code_builder.dart';

String write(Library library) {
  if (library.body.isEmpty) return '';
  final emitter = DartEmitter(Allocator.simplePrefixing());
  return library.accept(emitter).toString();
}
