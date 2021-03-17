library struct_generator;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:struct_generator/src/generator.dart';

Builder struct_generator(BuilderOptions options) =>
    LibraryBuilder(StructGenerator(), generatedExtension: '.struct.dart');
