import 'package:code_builder/code_builder.dart';
import 'package:struct_generator/src/models.dart';
import 'package:struct_generator/src/template/struct_class_template.dart';

class LibraryTemplate {
  final LibrarySpec _library;

  LibraryTemplate(this._library);

  Library inflate() => Library((lib) => lib
    ..directives.addAll(_importDirectives())
    ..body.addAll([
      for (final struct in _library.structs) ...[
        StructClassTemplate(struct).inflate(),
      ],
    ]));

  Iterable<Directive> _importDirectives() =>
      _uris().map((url) => Directive.import(url));

  Iterable<String> _uris() {
    final uris = <String>{};
    for (final struct in _library.structs) {
      for (final field in struct.fields) {
        final uri = field.type.url;
        if (uri != null) uris.add(uri);
        for (final validator in field.validators) {
          final uri = validator.url;
          if (uri != null) uris.add(uri);
        }
      }
    }
    return uris;
  }
}
