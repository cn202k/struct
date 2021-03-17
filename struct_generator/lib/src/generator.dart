import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:struct_generator/src/iinflater.dart';
import 'package:struct_generator/src/parser.dart';
import 'package:struct_generator/src/writer.dart';

class StructGenerator extends Generator {
  @override
  FutureOr<String> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) =>
      write(inflate(parse(library)));
}
