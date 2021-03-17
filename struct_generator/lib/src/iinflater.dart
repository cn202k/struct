import 'package:code_builder/code_builder.dart';
import 'package:struct_generator/src/models.dart';
import 'package:struct_generator/src/template/struct_class.dart';

Iterable<Spec> inflate(LibrarySpec lib) => [
      for (final struct in lib.structs) ...[
        StructClass(struct).inflate(),
      ],
    ];
