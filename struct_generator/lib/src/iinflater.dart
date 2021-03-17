import 'package:code_builder/code_builder.dart';
import 'package:struct_generator/src/models.dart';
import 'package:struct_generator/src/template/library_template.dart';

Library inflate(LibrarySpec library) => LibraryTemplate(library).inflate();
